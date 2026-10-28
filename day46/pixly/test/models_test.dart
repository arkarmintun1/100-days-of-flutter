import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/models/photos_page.dart';

Map<String, dynamic> fixture(String name) =>
    json.decode(File('test/fixtures/$name.json').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('parses a curated page (no total_results, has next_page)', () {
    final page = PhotosPage.fromJson(fixture('curated_page1'));
    expect(page.page, 1);
    expect(page.perPage, 12);
    expect(page.photos, hasLength(12));
    expect(page.totalResults, isNull);
    expect(page.hasMore, isTrue);
  });

  test('last page has no next_page => hasMore is false', () {
    final page = PhotosPage.fromJson(fixture('curated_last_page'));
    expect(page.hasMore, isFalse);
  });

  test('parses a search page with total_results', () {
    final page = PhotosPage.fromJson(fixture('search_nature'));
    expect(page.totalResults, 10000);
  });

  test('Photo.fromJson maps snake_case fields and src sizes', () {
    final json = fixture('curated_page1')['photos'][0] as Map<String, dynamic>;
    final photo = Photo.fromJson(json);
    expect(photo.photographer, json['photographer']);
    expect(photo.photographerUrl, json['photographer_url']);
    expect(photo.avgColor, json['avg_color']);
    expect(photo.src.medium, json['src']['medium']);
    expect(photo.aspectRatio, closeTo(json['width'] / json['height'], 1e-9));
  });

  test('toJson -> fromJson round trip keeps the data', () {
    final json = fixture('curated_page1')['photos'][3] as Map<String, dynamic>;
    final photo = Photo.fromJson(json);
    final copy = Photo.fromJson(photo.toJson());
    // Freezed's == compares every field, including the nested src.
    expect(copy, photo);
    expect(identical(copy, photo), isFalse);
  });

  test('toJson writes nested models as maps (explicit_to_json)', () {
    final json = fixture('curated_page1')['photos'][0] as Map<String, dynamic>;
    final photo = Photo.fromJson(json);
    expect(photo.toJson()['src'], isA<Map<String, dynamic>>());
    expect(photo.toJson()['photographer_url'], json['photographer_url']);
  });

  test('missing fields use the @Default values', () {
    final photo = Photo.fromJson({'id': 1, 'src': <String, dynamic>{}});
    expect(photo.photographer, 'Unknown');
    expect(photo.avgColor, '#9E9E9E');
    expect(photo.width, 0);
    expect(photo.aspectRatio, 1);
    expect(photo.src.medium, '');

    final page = PhotosPage.fromJson({});
    expect(page.page, 1);
    expect(page.perPage, 15);
    expect(page.photos, isEmpty);
    expect(page.hasMore, isFalse);
  });

  test('a photo without an id or src cannot be parsed', () {
    expect(
      () => Photo.fromJson({'src': <String, dynamic>{}}),
      throwsA(isA<TypeError>()),
    );
    expect(() => Photo.fromJson({'id': 1}), throwsA(isA<TypeError>()));
  });

  test('copyWith changes only the given fields', () {
    final photo = PhotosPage.fromJson(fixture('curated_page1')).photos.first;
    final edited = photo.copyWith(alt: 'A cat');
    expect(edited.alt, 'A cat');
    expect(edited.id, photo.id);
    expect(edited.src, same(photo.src));
    expect(edited, isNot(photo));
  });

  test('lists inside a Freezed model cannot be changed in place', () {
    final page = PhotosPage.fromJson(fixture('curated_page1'));
    expect(() => page.photos.clear(), throwsUnsupportedError);
  });
}
