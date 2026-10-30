// Prints test coverage per layer from coverage/lcov.info.
//
//   fvm flutter test --coverage
//   fvm dart run tool/coverage_summary.dart
//
// Generated files (*.g.dart, *.freezed.dart) are left out: we test our
// code, not the generators'.
// A command-line tool: printing is its job.
// ignore_for_file: avoid_print

import 'dart:io';

void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    stderr.writeln('No coverage/lcov.info. Run: fvm flutter test --coverage');
    exit(1);
  }

  // lcov: "SF:<file>" starts a file, "DA:<line>,<hits>" is one line.
  final perFile = <String, (int found, int hit)>{};
  String? current;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      current = line.substring(3);
    } else if (line.startsWith('DA:') && current != null) {
      final hits = int.parse(line.split(',')[1]);
      final (found, hit) = perFile[current] ?? (0, 0);
      perFile[current] = (found + 1, hit + (hits > 0 ? 1 : 0));
    }
  }

  bool generated(String path) =>
      path.endsWith('.g.dart') || path.endsWith('.freezed.dart');

  for (final layer in ['domain', 'data', 'presentation']) {
    var found = 0, hit = 0;
    final missed = <String>[];
    for (final MapEntry(key: path, value: (f, h)) in perFile.entries) {
      if (!path.contains('lib/$layer/') || generated(path)) continue;
      found += f;
      hit += h;
      if (h < f) missed.add('  ${path.split('lib/').last}: ${f - h} lines');
    }
    final percent = found == 0 ? 100.0 : hit * 100 / found;
    print('$layer: ${percent.toStringAsFixed(1)}% ($hit of $found lines)');
    missed.forEach(print);
  }
}
