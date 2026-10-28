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
    expect(copy.id, photo.id);
    expect(copy.src.tiny, photo.src.tiny);
    expect(copy.alt, photo.alt);
  });
}
