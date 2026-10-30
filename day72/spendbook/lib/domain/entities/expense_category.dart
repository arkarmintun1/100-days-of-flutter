/// What an expense was for.
///
/// Not just `Category`: Flutter's foundation library already has a class
/// with that name, and importing both would be ambiguous.
///
/// Only the business meaning lives here. Labels, icons and colors are UI
/// and belong to the presentation layer.
enum ExpenseCategory {
  food,
  transport,
  shopping,
  bills,
  entertainment,
  health,
  other,
}
