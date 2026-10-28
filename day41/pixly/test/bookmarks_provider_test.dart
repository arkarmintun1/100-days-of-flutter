import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/bookmarks_provider.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/memory_bookmarks.dart';

void main() {
  final photos = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos;

  test('toggle adds a bookmark, toggling again removes it', () async {
    final provider = BookmarksProvider(MemoryBookmarksStorage());

    await provider.toggle(photos[0]);
    expect(provider.isBookmarked(photos[0].id), isTrue);

    await provider.toggle(photos[0]);
    expect(provider.isBookmarked(photos[0].id), isFalse);
    expect(provider.photos, isEmpty);
  });

  test('the newest bookmark comes first', () async {
    final provider = BookmarksProvider(MemoryBookmarksStorage());

    await provider.toggle(photos[0]);
    await provider.toggle(photos[1]);

    expect(provider.photos.map((p) => p.id), [photos[1].id, photos[0].id]);
  });

  test(
    'bookmarks are saved and loaded again (like restarting the app)',
    () async {
      final storage = MemoryBookmarksStorage();
      final first = BookmarksProvider(storage);
      await first.toggle(photos[0]);
      await first.toggle(photos[1]);

      final second = BookmarksProvider(storage); // a fresh start
      expect(second.photos.map((p) => p.id), [photos[1].id, photos[0].id]);
      expect(second.photos.first.photographer, photos[1].photographer);
    },
  );

  test('a broken saved item is skipped, the rest still load', () {
    final storage = MemoryBookmarksStorage([
      jsonEncode(photos[0].toJson()),
      'not json',
      jsonEncode({'hello': 'world'}),
    ]);

    final provider = BookmarksProvider(storage);

    expect(provider.photos.map((p) => p.id), [photos[0].id]);
  });

  test('listeners hear about a change before it is saved', () async {
    final storage = MemoryBookmarksStorage();
    final provider = BookmarksProvider(storage);
    final events = <String>[];
    provider.addListener(() => events.add('notify'));
    storage.onWrite = () => events.add('write');

    await provider.toggle(photos[0]);

    expect(events, ['notify', 'write']);
  });

  test('a failed save is reported, the next save stores it', () async {
    final storage = MemoryBookmarksStorage()..failWrites = true;
    final provider = BookmarksProvider(storage);

    expect(await provider.toggle(photos[0]), isFalse);
    expect(provider.isBookmarked(photos[0].id), isTrue); // still shown
    expect(storage.items, isEmpty); // but not saved

    storage.failWrites = false;
    expect(await provider.toggle(photos[1]), isTrue);

    // The whole list is written, so photo 0 is saved now too.
    final restarted = BookmarksProvider(storage);
    expect(restarted.photos.map((p) => p.id), [photos[1].id, photos[0].id]);
  });
}
