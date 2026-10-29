import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:motion_lab/main.dart';
import 'package:motion_lab/products.dart';
import 'package:motion_lab/screens/gallery_screen.dart';
import 'package:motion_lab/screens/product_screen.dart';

void main() {
  Future<void> openGallery(WidgetTester tester) async {
    await tester.pumpWidget(const MotionLabApp());
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
  }

  testWidgets('tapping a product flies its picture to the detail screen', (
    tester,
  ) async {
    await openGallery(tester);
    final cell = tester.getRect(find.byType(ProductPicture).first);

    await tester.tap(find.text('Headphones'));
    await tester.pump(); // the route is pushed, the flight starts
    await tester.pump(const Duration(milliseconds: 200)); // halfway

    // The flight shuttle: corners between rounded (16) and square (0).
    final shuttle = find.byWidgetPredicate(
      (w) => w is ProductPicture && w.radius > 0 && w.radius < 16,
    );
    expect(shuttle, findsOneWidget);

    // Mid-flight it is bigger than its grid cell, but not yet full width.
    final flying = tester.getRect(shuttle);
    expect(flying.width, greaterThan(cell.width));
    expect(flying.width, lessThan(800));

    await tester.pumpAndSettle();
    expect(find.byType(ProductScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Headphones'), findsOneWidget);

    // Back: the picture flies home and the grid is there again.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(ProductScreen), findsNothing);
    expect(find.text('Camera'), findsOneWidget);
  });

  test('every product has its own id, so every Hero tag is unique', () {
    final ids = products.map((p) => p.id);
    expect(ids.toSet(), hasLength(products.length));
  });

  testWidgets('a link to a product that does not exist opens the grid', (
    tester,
  ) async {
    await openGallery(tester);
    final context = tester.element(find.text('Gallery').first);
    context.go('/gallery/99');
    await tester.pumpAndSettle();

    expect(find.byType(ProductScreen), findsNothing);
    expect(find.text('Headphones'), findsOneWidget);
  });
}
