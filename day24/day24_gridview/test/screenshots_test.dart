// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:day24_gridview/examples/explore_grid.dart';
import 'package:day24_gridview/examples/grid_count.dart';
import 'package:day24_gridview/examples/grid_extent.dart';
import 'package:day24_gridview/examples/main_axis_extent.dart';
import 'package:day24_gridview/examples/product_grid.dart';

import 'screenshot_helper.dart';

Widget app(Widget home) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(colorSchemeSeed: Colors.blue),
  home: home,
);

void main() {
  setUpAll(loadRealFonts);

  testWidgets(
    'grid_count',
    (t) => screenshot(t, 'grid_count', app(const GridCountExample())),
  );
  testWidgets(
    'grid_extent_phone',
    (t) => screenshot(t, 'grid_extent_phone', app(const GridExtentExample())),
  );
  testWidgets(
    'grid_extent_tablet',
    (t) => screenshot(
      t,
      'grid_extent_tablet',
      app(const GridExtentExample()),
      size: const Size(820, 1180),
      pixelRatio: 1.0,
    ),
  );
  testWidgets(
    'explore_grid',
    (t) => screenshot(t, 'explore_grid', app(const ExploreGrid())),
  );
  testWidgets(
    'product_grid_phone',
    (t) => screenshot(t, 'product_grid_phone', app(const ProductGrid())),
  );
  testWidgets(
    'product_grid_tablet',
    (t) => screenshot(
      t,
      'product_grid_tablet',
      app(const ProductGrid()),
      size: const Size(820, 1180),
      pixelRatio: 1.0,
    ),
  );
  testWidgets(
    'main_axis_extent',
    (t) => screenshot(t, 'main_axis_extent', app(const FixedHeightGrid())),
  );
  testWidgets(
    'bug_main_axis_extent_16',
    (t) => screenshot(
      t,
      'bug_main_axis_extent_16',
      app(
        Scaffold(
          appBar: AppBar(title: const Text('mainAxisExtent: 16')),
          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisExtent: 16,
            ),
            itemBuilder: (_, i) => Container(
              color: Colors.blue.shade200,
              child: Text('Card ${i + 1}'),
            ),
          ),
        ),
      ),
    ),
  );
}
