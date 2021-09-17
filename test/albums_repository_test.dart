import 'package:flutter_test/flutter_test.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_cache.dart';
import 'package:my_albums6/model/albums_repository.dart';
import 'package:my_albums6/model/albums_service.dart';

void main(){
  AlbumsService albumsService = AlbumsService();
  AlbumsCache albumsCache = AlbumsCache();
  AlbumsRepository albumsRepository = AlbumsRepository(albumsService, albumsCache);
  List<Album> albums = [];
  for(int i = 1; i < 100; ++i) {
    albums.add(
      Album(
        id: i,
        name: "$i",
        favorite: i % 2 == 0,
        userId: i % 30,
      )
    );
  }
  test("", (){
    expect(
      albumsRepository.getAlbums(),
      emits(AlbumsResponse.fromAlbums(albums, DateTime.now)),
    );
  });
}