import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/screens/home_screen.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('app starts on HomeScreen', (tester) async {
    // testApp builds the real PixlyApp with every provider it needs.
    await tester.pumpWidget(testApp());
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
