import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:day24_gridview/examples/grid_count.dart';
import 'package:day24_gridview/examples/grid_extent.dart';
import 'package:day24_gridview/examples/main_axis_extent.dart';
import 'package:day24_gridview/examples/product_grid.dart';

/// Sets a logical screen size for the test (devicePixelRatio = 1).
void setScreen(WidgetTester tester, double width, double height) {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Number of distinct x positions among the given widgets = columns.
int columnCount(WidgetTester tester, Finder finder) {
  return tester
      .widgetList(finder)
      .map((w) => tester.getTopLeft(find.byWidget(w)).dx.round())
      .toSet()
      .length;
}

void main() {
  testWidgets('GridView.count(crossAxisCount: 3) puts 3 tiles per row', (
    tester,
  ) async {
    setScreen(tester, 390, 844);
    await tester.pumpWidget(const MaterialApp(home: GridCountExample()));

    final one = tester.getTopLeft(find.text('1'));
    final three = tester.getTopLeft(find.text('3'));
    final four = tester.getTopLeft(find.text('4'));
    expect(one.dy, three.dy, reason: 'items 1-3 share a row');
    expect(four.dy, greaterThan(one.dy), reason: 'item 4 starts row 2');
  });

  group('MaxCrossAxisExtent(200) + spacing 12 + padding 12', () {
    for (final (width, expected) in [
      (390.0, 2),
      (768.0, 4),
      (820.0, 4),
      (1024.0, 5),
    ]) {
      testWidgets('width $width -> $expected columns', (tester) async {
        setScreen(tester, width, 1400);
        await tester.pumpWidget(const MaterialApp(home: ProductGrid()));
        expect(columnCount(tester, find.byType(ProductCard)), expected);
        expect(tester.takeException(), isNull, reason: 'no overflow');
      });
    }
  });

  testWidgets('childAspectRatio 0.75 => height = width / 0.75', (tester) async {
    setScreen(tester, 390, 844);
    await tester.pumpWidget(const MaterialApp(home: ProductGrid()));
    final cell = tester.getSize(
      find
          .ancestor(
            of: find.byType(ProductCard).first,
            matching: find.byType(KeyedSubtree),
          )
          .first,
    );
    expect(cell.height, closeTo(cell.width / 0.75, 0.01));
    // Numbers quoted in the article for a 390-wide phone.
    expect(cell.width, closeTo(177, 0.01));
    expect(cell.height, closeTo(236, 0.01));
  });

  group('GridView.extent(maxCrossAxisExtent: 150, spacing 8, padding 8)', () {
    for (final (width, expected) in [(390.0, 3), (820.0, 6)]) {
      testWidgets('width $width -> $expected columns', (tester) async {
        setScreen(tester, width, 1180);
        await tester.pumpWidget(const MaterialApp(home: GridExtentExample()));
        final tiles = find.descendant(
          of: find.byType(GridView),
          matching: find.byType(Container),
        );
        expect(columnCount(tester, tiles), expected);
      });
    }
  });

  testWidgets('mainAxisExtent: 120 => every tile is 120 high', (tester) async {
    setScreen(tester, 390, 844);
    await tester.pumpWidget(const MaterialApp(home: FixedHeightGrid()));
    final cell = tester.getSize(
      find
          .ancestor(
            of: find.byType(Card).first,
            matching: find.byType(KeyedSubtree),
          )
          .first,
    );
    expect(cell.height, 120);
  });

  testWidgets(
    'BUG demo: mainAxisExtent: 16 (instead of mainAxisSpacing) => 16px tiles',
    (tester) async {
      setScreen(tester, 390, 844);
      await tester.pumpWidget(
        MaterialApp(
          home: GridView.builder(
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisExtent: 16, // <- the mistake
            ),
            itemBuilder: (_, i) =>
                ColoredBox(color: Colors.red, key: ValueKey(i)),
          ),
        ),
      );
      expect(tester.getSize(find.byKey(const ValueKey(0))).height, 16);
    },
  );

  testWidgets('GridView.builder only builds what is visible', (tester) async {
    setScreen(tester, 390, 844);
    var built = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: GridView.builder(
          itemCount: 1000,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (_, i) {
            built++;
            return Text('Item $i');
          },
        ),
      ),
    );
    expect(built, lessThan(1000));
    // ignore: avoid_print
    print('GridView.builder built $built of 1000 items');
  });
}
