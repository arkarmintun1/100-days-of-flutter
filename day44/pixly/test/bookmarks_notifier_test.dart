import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/bookmarks_notifier.dart';
import 'package:pixly/providers/dependencies.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/memory_bookmarks.dart';

void main() {
  final photos = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos;

  ProviderContainer containerWith(MemoryBookmarksStorage storage) =>
      ProviderContainer.test(
        overrides: [bookmarksStorageProvider.overrideWithValue(storage)],
      );

  List<int> ids(List<Photo> photos) => [for (final p in photos) p.id];

  test('toggle adds a bookmark, toggling again removes it', () async {
    final container = containerWith(MemoryBookmarksStorage());
    final notifier = container.read(bookmarksProvider.notifier);

    await notifier.toggle(photos[0]);
    expect(notifier.isBookmarked(photos[0].id), isTrue);

    await notifier.toggle(photos[0]);
    expect(container.read(bookmarksProvider), isEmpty);
  });

  test('the newest bookmark comes first', () async {
    final container = containerWith(MemoryBookmarksStorage());
    final notifier = container.read(bookmarksProvider.notifier);

    await notifier.toggle(photos[0]);
    await notifier.toggle(photos[1]);

    expect(ids(container.read(bookmarksProvider)), [
      photos[1].id,
      photos[0].id,
    ]);
  });

  test('every change is a new list (so listeners hear about it)', () async {
    final container = containerWith(MemoryBookmarksStorage());
    final lists = <List<Photo>>[];
    container.listen(bookmarksProvider, (_, next) => lists.add(next));
    final before = container.read(bookmarksProvider);

    await container.read(bookmarksProvider.notifier).toggle(photos[0]);

    expect(lists, hasLength(1));
    expect(lists.single, isNot(same(before)));
  });

  test('bookmarks are loaded again in a new container (a restart)', () async {
    final storage = MemoryBookmarksStorage();
    final first = containerWith(storage).read(bookmarksProvider.notifier);
    await first.toggle(photos[0]);
    await first.toggle(photos[1]);

    final second = containerWith(storage).read(bookmarksProvider);
    expect(ids(second), [photos[1].id, photos[0].id]);
    expect(second.first.photographer, photos[1].photographer);
  });

  test('a broken saved item is skipped, the rest still load', () {
    final container = containerWith(
      MemoryBookmarksStorage([
        jsonEncode(photos[0].toJson()),
        'not json',
        jsonEncode({'hello': 'world'}),
      ]),
    );

    expect(ids(container.read(bookmarksProvider)), [photos[0].id]);
  });

  test('listeners hear about a change before it is saved', () async {
    final storage = MemoryBookmarksStorage();
    final container = containerWith(storage);
    final events = <String>[];
    container.listen(bookmarksProvider, (_, _) => events.add('notify'));
    storage.onWrite = () => events.add('write');

    await container.read(bookmarksProvider.notifier).toggle(photos[0]);

    expect(events, ['notify', 'write']);
  });

  test('a failed save is reported, the next save stores it', () async {
    final storage = MemoryBookmarksStorage()..failWrites = true;
    final container = containerWith(storage);
    final notifier = container.read(bookmarksProvider.notifier);

    expect(await notifier.toggle(photos[0]), isFalse);
    expect(notifier.isBookmarked(photos[0].id), isTrue); // still shown
    expect(storage.items, isEmpty); // but not saved

    storage.failWrites = false;
    expect(await notifier.toggle(photos[1]), isTrue);

    expect(ids(containerWith(storage).read(bookmarksProvider)), [
      photos[1].id,
      photos[0].id,
    ]);
  });
}
