import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/assets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every AppAssets path is bundled', () async {
    for (final path in [
      AppAssets.logo,
      AppAssets.emptyPhotos,
      AppAssets.placeholder,
    ]) {
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(0), reason: path);
    }
  });

  test('2.0x and 3.0x variants are bundled for placeholder.png', () async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final variants = manifest
        .getAssetVariants(AppAssets.placeholder)!
        .map((v) => v.targetDevicePixelRatio)
        .toSet();
    expect(variants, containsAll(<double?>[null, 2.0, 3.0]));
  });
}
