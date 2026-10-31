import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// Day 96: `context.l10n.addExpense` instead of
/// `AppLocalizations.of(context).addExpense`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
