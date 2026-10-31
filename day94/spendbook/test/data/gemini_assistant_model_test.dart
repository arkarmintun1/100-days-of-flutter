import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:spendbook/data/ai/assistant_tools.dart';
import 'package:spendbook/data/ai/gemini_assistant_model.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/assistant_model.dart';
import 'package:spendbook/domain/usecases/add_expense.dart';

import '../helpers/fake_expense_repository.dart';
import '../helpers/fake_gemini.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  setUp(FakeGemini.reset);

  final now = DateTime(2026, 10, 28, 10);
  late FakeExpenseRepository repository;
  var ids = 0;

  late FakeGemini gemini;

  GeminiAssistantModel model(List<http.Response> answers) {
    repository = FakeExpenseRepository();
    gemini = FakeGemini(
      () => answers.isEmpty
          ? throw http.ClientException('Failed host lookup')
          : answers.removeAt(0),
    );
    return GeminiAssistantModel(
      FirebaseAI.googleAI(),
      instructions: 'You are a test.',
      tools: AssistantTools(
        addExpense: AddExpense(
          repository,
          newId: () => 'id-${++ids}',
          now: () => now,
        ),
        expenses: () async => right(repository.expenses),
        now: () => now,
      ),
      httpClient: gemini.client,
    );
  }

  test('runs the calls Gemini asks for, sends the results back', () async {
    final assistant = model([
      // "Log my $5 coffee and $20 Grab": two calls in one answer.
      FakeGemini.functionCalls([
        (
          'add_expense',
          {'title': 'Coffee', 'amount': '5.00', 'category': 'food'},
        ),
        (
          'add_expense',
          {'title': 'Grab', 'amount': '20', 'category': 'transport'},
        ),
      ]),
      FakeGemini.text('Added both.'),
    ]);
    final actions = <AssistantAction>[];
    assistant.actions.listen(actions.add);

    final reply = await assistant.send('Log my 5 coffee and 20 Grab').toList();

    expect(reply, ['Added both.']);
    // Saved through the real AddExpense use case.
    expect(repository.expenses.map((e) => (e.title, e.amountCents)), [
      ('Coffee', 500),
      ('Grab', 2000),
    ]);
    expect(repository.expenses.last.category, ExpenseCategory.transport);
    expect(actions, hasLength(2));

    final requests = gemini.bodies;
    // 1st request: the tools are declared.
    final declarations =
        ((requests.first['tools']! as List).single
                as Map)['functionDeclarations']
            as List;
    expect(declarations.map((d) => (d as Map)['name']), [
      'add_expense',
      'get_spending',
    ]);
    // 2nd request: question, the model's calls, then both results.
    final contents = requests.last['contents']! as List;
    expect(contents, hasLength(3));
    final results = (contents.last as Map)['parts'] as List;
    expect(results, [
      {
        'functionResponse': {
          'name': 'add_expense',
          'response': {'saved': true, 'id': 'id-1'},
        },
      },
      {
        'functionResponse': {
          'name': 'add_expense',
          'response': {'saved': true, 'id': 'id-2'},
        },
      },
    ]);
  });

  test('calls run in order: a read after an add sees it', () async {
    final assistant = model([
      FakeGemini.functionCalls([
        (
          'add_expense',
          {'title': 'Coffee', 'amount': '5.00', 'category': 'food'},
        ),
        ('get_spending', {'month': '2026-10'}),
      ]),
      FakeGemini.text(r'You spent $5.00.'),
    ]);

    await assistant.send('Add a 5 coffee, then tell me my total').toList();

    final results =
        ((gemini.bodies.last['contents']! as List).last as Map)['parts']
            as List;
    final spending =
        ((results.last as Map)['functionResponse'] as Map)['response'] as Map;
    expect(spending['total'], '5.00');
  });

  test("a rule the domain rejects goes back to Gemini as an error", () async {
    final assistant = model([
      FakeGemini.functionCalls([
        (
          'add_expense',
          {
            'title': 'Concert',
            'amount': '80',
            'category': 'entertainment',
            'date': '2026-12-24', // in the future
          },
        ),
      ]),
      FakeGemini.text("I can't add future expenses."),
    ]);

    await assistant.send('Add the concert on Christmas Eve').toList();

    expect(repository.expenses, isEmpty);
    final requests = gemini.bodies;
    final response =
        (((requests.last['contents']! as List).last as Map)['parts'] as List)
            .single;
    expect(((response as Map)['functionResponse'] as Map)['response'], {
      'error': "The date can't be in the future.",
    });
  });

  test('a model that never stops calling functions is stopped', () async {
    final assistant = model([
      for (var i = 0; i < 10; i++)
        FakeGemini.functionCalls([
          ('get_spending', {'month': '2026-10'}),
        ]),
    ]);

    await expectLater(
      assistant.send('How much?'),
      emitsError(isA<AiFailure>()),
    );
  });

  test(
    'after a failure, the next message starts from a valid history',
    () async {
      final assistant = model([
        // 1 answer + 5 rounds of calls: stopped with a call left unanswered.
        for (var i = 0; i < 6; i++)
          FakeGemini.functionCalls([
            ('get_spending', {'month': '2026-10'}),
          ]),
        FakeGemini.text('Hello!'),
      ]);
      await expectLater(
        assistant.send('How much?'),
        emitsError(isA<AiFailure>()),
      );

      expect(await assistant.send('Hi').toList(), ['Hello!']);
      // Only the new message: the unfinished turn was dropped.
      final contents = gemini.bodies.last['contents']! as List;
      expect(contents, hasLength(1));
    },
  );

  test(
    'saved, then cut off: the user is told, and the history keeps it',
    () async {
      final assistant = model([
        FakeGemini.functionCalls([
          (
            'add_expense',
            {'title': 'Coffee', 'amount': '4.50', 'category': 'food'},
          ),
        ]),
        // Then the connection drops before Gemini's answer.
      ]);

      await expectLater(
        assistant.send('Log a 4.50 coffee'),
        emitsError(
          isA<AiFailure>().having(
            (f) => f.message,
            'message',
            startsWith(
              "The expense above was saved, but the answer didn't "
              'finish.',
            ),
          ),
        ),
      );
      expect(repository.expenses, hasLength(1));

      // A retry goes with the earlier message and a note of the save,
      // so Gemini knows the coffee is already there.
      await expectLater(assistant.send('Try again'), emitsError(anything));
      final contents = gemini.bodies.last['contents']! as List;
      expect(contents, hasLength(3));
      final note =
          (((contents[1] as Map)['parts'] as List).single as Map)['text'];
      expect((contents[1] as Map)['role'], 'model');
      expect(note, contains('"Coffee", 4.50 USD, food, id id-'));
    },
  );

  test('after close, a pending answer runs no more functions', () async {
    final assistant = model([
      FakeGemini.functionCalls([
        (
          'add_expense',
          {'title': 'Coffee', 'amount': '4.50', 'category': 'food'},
        ),
      ]),
      FakeGemini.text('Added.'),
    ]);

    final reply = assistant.send('Log a 4.50 coffee').toList();
    assistant.close(); // the screen closes while Gemini is answering

    expect(await reply, isEmpty);
    expect(repository.expenses, isEmpty);
  });

  test('no connection is a NetworkFailure', () async {
    final assistant = model([]);

    await expectLater(assistant.send('Hi'), emitsError(isA<NetworkFailure>()));
  });
}
