import 'package:rive/rive.dart';

/// Which renderer draws the .riv files.
///
/// Factory.rive is Rive's own renderer (the default in Rive's docs).
/// Widget tests switch to Factory.flutter: it paints with Flutter's canvas,
/// so the screenshots can capture it.
Factory riveFactory = Factory.rive;
