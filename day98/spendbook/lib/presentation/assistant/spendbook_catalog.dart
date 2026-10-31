import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import '../../domain/entities/expense_category.dart';
import '../formatting/money.dart';
import '../widgets/category_look.dart';

/// The widgets Gemini may use in its answers (Day 73): a few of GenUI's
/// basic ones, plus two of Spendbook's own.
final spendbookCatalog = BasicCatalogItems.asCatalog()
    .copyWithout(
      // No media in a money app (and fewer tokens in the prompt).
      itemsToRemove: [
        BasicCatalogItems.audioPlayer,
        BasicCatalogItems.video,
        BasicCatalogItems.image,
      ],
    )
    .copyWith(newItems: [spendingCard, tipCard]);

/// How much went into one category, against an optional budget.
final spendingCard = CatalogItem(
  name: 'SpendingCard',
  dataSchema: S.object(
    description: "One category's spending this month.",
    properties: {
      'category': S.string(
        enumValues: [for (final c in ExpenseCategory.values) c.name],
      ),
      'amount': S.number(description: 'Spent, in USD, e.g. 45.20.'),
      'share': S.number(
        description: "This category's part of the month's total, 0 to 1.",
      ),
    },
    required: ['category', 'amount'],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as JsonMap;
    // The model fills these in: check them like any other outside data.
    final category =
        ExpenseCategory.values.asNameMap()[data['category']] ??
        ExpenseCategory.other;
    // Types are checked too: "45.20" (a string) is not a number here.
    final amount = switch (data['amount']) {
      // Up to a billion: more is a mistake (and n * 100 could overflow).
      final num n when n.isFinite && n >= 0 && n <= 1e9 => n,
      _ => 0,
    };
    final share = switch (data['share']) {
      final num n when n.isFinite => n.toDouble().clamp(0.0, 1.0),
      _ => null,
    };
    return Card(
      child: ListTile(
        leading: Icon(category.icon, color: category.color),
        title: Text(category.label),
        subtitle: share == null
            ? null
            : LinearProgressIndicator(value: share, color: category.color),
        trailing: Text(
          formatCents((amount * 100).round()),
          style: Theme.of(itemContext.buildContext).textTheme.titleMedium,
        ),
      ),
    );
  },
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "SpendingCard",
          "category": "food",
          "amount": 45.2,
          "share": 0.24
        }
      ]
    ''',
  ],
);

/// A tip, colored by its mood: the model decides how the advice should feel.
final tipCard = CatalogItem(
  name: 'TipCard',
  dataSchema: S.object(
    description: 'A short piece of advice about the spending.',
    properties: {
      'text': S.string(description: 'At most 25 words.'),
      'mood': S.string(
        enumValues: ['good', 'neutral', 'warning'],
        description: 'good: on track. warning: over budget or a big spend.',
      ),
    },
    required: ['text', 'mood'],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as JsonMap;
    final colors = Theme.of(itemContext.buildContext).colorScheme;
    final (icon, background) = switch (data['mood']) {
      'good' => (Icons.thumb_up_outlined, colors.primaryContainer),
      'warning' => (Icons.warning_amber, colors.errorContainer),
      _ => (Icons.lightbulb_outline, colors.surfaceContainerHighest),
    };
    return Card(
      color: background,
      child: ListTile(
        leading: Icon(icon),
        title: Text(switch (data['text']) {
          final String text => text,
          _ => '',
        }),
      ),
    );
  },
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "TipCard",
          "text": "You're at 62% of your budget with 3 days left.",
          "mood": "good"
        }
      ]
    ''',
  ],
);
