import 'package:flutter/material.dart';

/// The corrected delegate from the "Common Mistake" section.
const fixedDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 0.75,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16, // ✅
);

Widget fixedGrid() => GridView.builder(
  itemCount: 4,
  gridDelegate: fixedDelegate,
  itemBuilder: (_, i) => Text('$i'),
);
