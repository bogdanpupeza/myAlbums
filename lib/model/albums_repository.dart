import 'dart:io';

import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_cache.dart';
import 'package:my_albums6/model/albums_service.dart';
import 'package:rxdart/rxdart.dart';

class AlbumsRepository {
  final AlbumsService albumsService;
  final AlbumsCache albumsCache;

  AlbumsRepository(
    this.albumsService,
    this.albumsCache,
  );

  DateTime? _lastUpdate;

  Stream<List<int>> toggleAlbum(int id) {
    Stream<List<int>> favoritesStream = albumsCache.getFavorites();
    Stream<List<int>> actualFavorites = favoritesStream.map((favorites) {
      if (favorites.any((element) => element == id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
      albumsCache.setFavorites(favorites);
      return favorites;
    });
    return actualFavorites;
  }

  Stream<List<int>> getFavorites() {
    return albumsCache.getFavorites();
  }

  Stream<AlbumsResponse> getAlbums() {
    _lastUpdate = DateTime.now();

    Stream<DateTime?> dateStream = albumsCache.getLastDate();

    Stream<List<Album>> albumsStream =
    albumsService.getAlbums().map((albumsList) {
      albumsCache.setAlbums(albumsList);
      albumsCache.setDate(DateTime.now());
      return albumsList;
    }).onErrorResume((error, stackTrace) {
      if (error is SocketException) {
        return dateStream.flatMap((date) {
          _lastUpdate = date;
          return albumsCache.getAlbums();
        });
      }
      throw error;
    });
    return albumsStream.flatMap((albumsList) {
      return Stream.value(
          AlbumsResponse(albums: albumsList, lastUpdate: _lastUpdate));
    });
  }
}
