import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/albums_cache.dart';
import '../model/albums_service.dart';
import '../model/albums.dart';


class AlbumsRepository{

  final AlbumsService albumsService;
  final AlbumsCache albumsCache;
  AlbumsRepository(
    this.albumsService,
    this.albumsCache,
  );
  
  Stream<AlbumsResponse> getAlbums() async* {
    var _isError = false;
    var _lastUpdate;
    var albums = await albumsService.getAlbums().
    onError(
        (error, stackTrace)async {
          print(error);
          _isError = true;
          return await albumsCache.getAlbums();
        }
      ).whenComplete((){
        if(_isError == false) {
          _lastUpdate = DateTime.now();
        }
      });
    var albumsResponse = AlbumsResponse(albums: albums, lastUpdate: _lastUpdate);
    yield albumsResponse;
  }
}
