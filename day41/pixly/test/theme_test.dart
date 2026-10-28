import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';

void main() {
  test('light and dark themes carry PixlyColors', () {
    expect(AppTheme.lightTheme.extension<PixlyColors>(), PixlyColors.light);
    expect(AppTheme.darkTheme.extension<PixlyColors>(), PixlyColors.dark);
    expect(AppTheme.darkTheme.colorScheme.brightness, Brightness.dark);
  });

  test('PixlyColors.lerp blends halfway', () {
    final mid = PixlyColors.light.lerp(PixlyColors.dark, 0.5);
    expect(
      mid.shimmerBase,
      Color.lerp(
        PixlyColors.light.shimmerBase,
        PixlyColors.dark.shimmerBase,
        0.5,
      ),
    );
  });

  testWidgets('context.pixlyColors reads the extension', (tester) async {
    late PixlyColors read;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Builder(
          builder: (context) {
            read = context.pixlyColors;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(read, PixlyColors.dark);
  });

  testWidgets('AppBar title uses the bold titleLarge from the theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(appBar: AppBar(title: const Text('Pixly'))),
      ),
    );
    final style = tester
        .widget<RichText>(
          find
              .descendant(
                of: find.byType(AppBar),
                matching: find.byType(RichText),
              )
              .first,
        )
        .text
        .style!;
    final expected = Theme.of(
      tester.element(find.text('Pixly')),
    ).textTheme.titleLarge!;
    expect(style.fontSize, isNotNull);
    expect(style.fontSize, expected.fontSize);
    expect(style.fontWeight, FontWeight.bold);
    expect(style.fontFamily, 'Poppins');
  });

  test('theme uses the bundled Poppins font', () {
    expect(AppTheme.lightTheme.textTheme.bodyMedium!.fontFamily, 'Poppins');
    expect(AppTheme.lightTheme.textTheme.titleLarge!.fontFamily, 'Poppins');
  });
}
