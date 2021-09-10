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
        (error, stackTrace){
          print(error);
          _isError = true;
          return albumsCache.getAlbums();
        }
      ).whenComplete((){
        if(_isError == false) {
          _lastUpdate = DateTime.now();
        }
      });




    var albumsStream = Stream.fromIterable([albums]);
    //?????????????
    albumsStream.
    var outStream = albumsStream.map((albumsList){
        if(_isError == false)
          albumsCache.setData(albumsList);
        return AlbumsResponse(albums: albumsList, lastUpdate: _lastUpdate);
      });
    yield outStream;
  }
}