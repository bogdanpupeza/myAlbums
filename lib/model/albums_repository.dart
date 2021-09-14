import 'dart:io';

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

  DateTime? _lastUpdate;
  List<AlbumFavoriteStatus> albumsFavorites = [];

  Stream<List<AlbumFavoriteStatus>> toggleFavorite(int id){

    bool? favStat = albumsFavorites.firstWhere((element) => element.id==id).favoriteStatus;
    if(favStat == null)
      favStat = false;
    albumsFavorites.firstWhere((element) => element.id == id).favoriteStatus = !favStat;
    albumsCache.setFavorites(albumsFavorites);
    return Stream.fromIterable([albumsFavorites]);
  }
  
  Stream<AlbumsResponse> getAlbums(){
    DateTime? oldDate = _lastUpdate;
    _lastUpdate = DateTime.now();
    bool isError = false;
    Stream<List<Album>> albumsStream = 
    albumsService.getAlbums().handleError(
      (error, stackTrace){
        _lastUpdate = oldDate;
        isError = true;
        print("Albums from cache");
        return albumsCache.getAlbums();
      }
    )
    .map((albums){
      if (albumsFavorites.isEmpty) {
        albums.forEach((album) {
          albumsFavorites.add(
            new AlbumFavoriteStatus(
              id: album.id, 
              favoriteStatus: album.favorite,
            ));
        });
        print("EmptyFavorites");
        albumsCache.setFavorites(albumsFavorites);
      }

      albumsCache.getFavorites().map((favorites){
        albumsFavorites.forEach((fav){
          fav = favorites.firstWhere((album){
            return album.id == fav.id;
          });
        });
        albums.forEach((album) {
          album.favorite = favorites.firstWhere(
            (albumFav){
              return (album.id == albumFav.id);
            }
          ).favoriteStatus;
       });
      }
      );
      print(albumsFavorites.first.id);
      print(albums.first.favorite);
      return albums;
    });

    return albumsStream.map((albumsList){
      if(!isError){
        albumsCache.setData(albumsList);
      }
      return AlbumsResponse(albums: albumsList, lastUpdate: _lastUpdate);
    });
  }
  
  
}