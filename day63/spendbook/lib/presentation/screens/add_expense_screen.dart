import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/usecases/add_expense.dart';
import '../formatting/money.dart';
import '../providers/dependencies.dart';
import '../providers/expense_list.dart';
import '../widgets/category_look.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  var _category = ExpenseCategory.food;

  /// The currency the amount is typed in (Day 63).
  var _currency = appCurrency;
  late DateTime _date = ref.read(clockProvider)();

  /// A rule the domain rejected (AddExpense), shown above the button.
  String? _error;
  var _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = ref.read(clockProvider)();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 5),
      lastDate: now, // no future dates (the domain checks it too)
    );
    if (picked == null || !mounted) return;
    setState(() => _date = picked);
  }

  Future<void> _save() async {
    // The form only checks what the UI must: is the amount a number?
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    // What the form says now: the network call below takes a while, and
    // the fields could change meanwhile.
    final title = _title.text;
    final category = _category;
    final date = _date;
    final note = _note.text;
    final digits = decimalDigitsOf(_currency);
    final minorUnits = parseMinor(_amount.text, decimalDigits: digits)!;
    var cents = minorUnits;
    ForeignAmount? original;

    // Another currency: convert it first (the network, so it can fail).
    if (_currency != appCurrency) {
      original = ForeignAmount(
        currency: _currency,
        minorUnits: minorUnits,
        decimalDigits: digits,
      );
      final conversion = await ref.read(convertCurrencyProvider)(original);
      if (!mounted) return;
      switch (conversion) {
        case Left(value: final failure):
          setState(() {
            _saving = false;
            _error = failure.message;
          });
          return;
        case Right(value: final converted):
          cents = converted.cents;
      }
    }

    final result = await ref
        .read(expenseListProvider.notifier)
        .add(
          title: title,
          amountCents: cents,
          category: category,
          date: date,
          note: note,
          original: original,
        );
    if (!mounted) return;

    switch (result) {
      case Left(value: final failure):
        setState(() {
          _saving = false;
          _error = failure.message;
        });
      case Right():
        Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add expense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amount,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: const OutlineInputBorder(),
                      helperText: _currency == appCurrency
                          ? null
                          : 'Converted to $appCurrency when you save.',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (text) {
                      final digits = decimalDigitsOf(_currency);
                      if (parseMinor(text ?? '', decimalDigits: digits) !=
                          null) {
                        return null;
                      }
                      return digits == 0
                          ? 'Enter a whole amount like 1500'
                          : 'Enter an amount like 12.50';
                    },
                    autofocus: true,
                  ),
                ),
                const SizedBox(width: 12),
                DropdownMenu<String>(
                  initialSelection: _currency,
                  label: const Text('Currency'),
                  width: 120,
                  onSelected: (currency) {
                    if (currency != null) setState(() => _currency = currency);
                  },
                  dropdownMenuEntries: [
                    for (final currency in currencies)
                      DropdownMenuEntry(value: currency, label: currency),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              maxLength: AddExpense.maxTitleLength,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 8),
            Text('Category', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in ExpenseCategory.values)
                  ChoiceChip(
                    showCheckmark: false,
                    avatar: Icon(category.icon, color: category.color),
                    label: Text(category.label),
                    selected: category == _category,
                    onSelected: (_) => setState(() => _category = category),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(DateFormat.yMMMd().format(_date)),
              trailing: const Text('Change'),
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error case final error?) ...[
              const SizedBox(height: 16),
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
