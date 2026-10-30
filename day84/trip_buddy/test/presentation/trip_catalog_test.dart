import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:trip_buddy/domain/time_zones.dart';
import 'package:trip_buddy/presentation/chat/answer_parser.dart';
import 'package:trip_buddy/presentation/chat/trip_catalog.dart';

void main() {
  group('timeUntil', () {
    // 30 Oct 2026, 12:15 UTC.
    final now = DateTime.utc(2026, 10, 30, 12, 15);

    test('counts to the clock time in the place\'s own time zone', () {
      // London in December is on GMT (UTC+0): 21:40 there is 21:40 UTC.
      expect(
        timeUntil(DateTime(2026, 12, 12, 21, 40), 'Europe/London', now: now),
        const Duration(days: 43, hours: 9, minutes: 25),
      );
      // Singapore is UTC+8: 13 Dec 18:05 there is 10:05 UTC.
      expect(
        timeUntil(DateTime(2026, 12, 13, 18, 5), 'Asia/Singapore', now: now),
        const Duration(days: 43, hours: 21, minutes: 50),
      );
    });

    test('an unknown time zone is null; the past is negative', () {
      expect(
        timeUntil(DateTime(2026, 12, 12), 'Mars/Olympus', now: now),
        isNull,
      );
      expect(
        timeUntil(DateTime(2026, 1, 1), 'Asia/Singapore', now: now)!.isNegative,
        isTrue,
      );
    });
  });

  test('countdownText', () {
    expect(countdownText(const Duration(days: 43, hours: 9)), '43 days 9 h');
    expect(countdownText(const Duration(days: 1, hours: 2)), '1 day 2 h');
    expect(countdownText(const Duration(hours: 3, minutes: 20)), '3 h 20 min');
    expect(countdownText(const Duration(minutes: -5)), 'Started');
    expect(countdownText(null), 'Unknown time');
  });

  test('the parser splits text from UI, as the answer grows', () {
    var changes = 0;
    final parser = AnswerParser(tripCatalog, onChanged: () => changes++);
    addTearDown(parser.dispose);
    const create =
        '{"version":"v0.9","createSurface":'
        '{"surfaceId":"countdown","catalogId":"$basicCatalogId"}}';

    // Each update has the whole answer so far, cut anywhere.
    const answer = 'You fly in 43 days.\n$create\n';
    parser.update(answer.substring(0, 25));
    parser.update(answer);
    return Future<void>.delayed(Duration.zero, () {
      expect(parser.text.trim(), 'You fly in 43 days.');
      expect(parser.surfaceIds, ['countdown']);
      expect(changes, greaterThan(0));
    });
  });

  group('one piece with text and a whole message', () {
    const create =
        '{"version":"v0.9","createSurface":'
        '{"surfaceId":"countdown","catalogId":"$basicCatalogId"}}';
    const answer = 'You fly in 43 days.\n$create\n';

    test("GenUI 0.10.4's parser alone shows unfenced JSON as text", () async {
      final events = await Stream.value(
        answer,
      ).transform(const A2uiParserTransformer()).toList();

      expect(events.whereType<A2uiMessageEvent>(), isEmpty);
      expect(
        events.whereType<TextEvent>().map((e) => e.text).join(),
        contains('createSurface'),
      );
    });

    test('AnswerParser cuts it before the { and gets the message', () async {
      final parser = AnswerParser(tripCatalog, onChanged: () {});
      addTearDown(parser.dispose);

      parser.update(answer);
      parser.close();
      await Future<void>.delayed(Duration.zero);

      expect(parser.surfaceIds, ['countdown']);
      expect(parser.text, isNot(contains('createSurface')));
      expect(parser.text.trim(), 'You fly in 43 days.');
    });
  });

  test('a fenced answer cut anywhere still gives its text and UI', () async {
    const create =
        '{"version":"v0.9","createSurface":'
        '{"surfaceId":"countdown","catalogId":"$basicCatalogId"}}';
    const answer = 'You fly in 43 days.\n```json\n$create\n```\n';

    for (var cut = 1; cut < answer.length; cut++) {
      final parser = AnswerParser(tripCatalog, onChanged: () {});
      parser.update(answer.substring(0, cut));
      parser.update(answer);
      parser.close();
      await Future<void>.delayed(Duration.zero);

      expect(parser.surfaceIds, ['countdown'], reason: 'cut at $cut');
      expect(parser.text.trim(), 'You fly in 43 days.', reason: 'cut at $cut');
      parser.dispose();
    }
  });
}
