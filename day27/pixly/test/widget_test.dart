import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/main.dart';
import 'package:pixly/screens/home_screen.dart';

void main() {
  testWidgets('app starts on HomeScreen', (tester) async {
    await tester.pumpWidget(const PixlyApp());
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
