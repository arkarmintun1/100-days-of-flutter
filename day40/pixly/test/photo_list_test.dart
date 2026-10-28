import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/models/photo_list.dart';
import 'package:pixly/models/photos_page.dart';

import 'helpers/fake_adapter.dart';

void main() {
  final photos = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos;

  test('adds the new photos at the end, in order', () {
    final result = photos.sublist(0, 2).plusNew(photos.sublist(2, 4));
    expect(result.map((p) => p.id), photos.take(4).map((p) => p.id));
  });

  test('skips photos that are already in the list', () {
    final result = photos.sublist(0, 3).plusNew(photos.sublist(1, 5));
    expect(result.map((p) => p.id), photos.take(5).map((p) => p.id));
  });

  test('skips duplicates inside the new page too', () {
    final result = photos.sublist(0, 1).plusNew([photos[1], photos[1]]);
    expect(result.map((p) => p.id), [photos[0].id, photos[1].id]);
  });

  test('does not change the original list', () {
    final original = photos.sublist(0, 2);
    original.plusNew(photos.sublist(2, 3));
    expect(original, hasLength(2));
  });
}
