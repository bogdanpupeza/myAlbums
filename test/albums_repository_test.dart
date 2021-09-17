import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_cache.dart';
import 'package:my_albums6/model/albums_repository.dart';
import 'package:my_albums6/model/albums_service.dart';
import 'package:mockito/mockito.dart';

import 'albums_repository_test.mocks.dart';

@GenerateMocks([AlbumsCache, AlbumsService])
void main() {
  AlbumsService albumsService = MockAlbumsService();
  AlbumsCache albumsCache = MockAlbumsCache();
  AlbumsRepository albumsRepository =
      AlbumsRepository(albumsService, albumsCache);
  List<Album> albums = [];
  for (int i = 1; i <= 100; ++i) {
    albums.add(Album(
      id: i,
      name: "$i",
      favorite: i % 2 == 0,
      userId: i % 30,
    ));
  }

  DateTime date = DateTime.now();
  AlbumsResponse albumsResponse = AlbumsResponse(
    albums: albums,
    lastUpdate: date,
  );
  test("Test for getting albums", () {
    //.expect(actual, matcher)
    when(albumsCache.getLastDate()).thenAnswer((_) {
      return Stream.value(date);
    });
    when(albumsService.getAlbums()).thenAnswer((_) {
      return Stream.value(albums);
    });
    expect(albumsRepository.getAlbums(), emits(albumsResponse));
  });
}
