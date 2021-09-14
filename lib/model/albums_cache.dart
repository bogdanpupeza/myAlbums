import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/albums.dart';

class AlbumsCache{

  Stream<List<AlbumFavoriteStatus>> getFavorites(){
    List<AlbumFavoriteStatus> albumsFavorites = [];
    List<dynamic> responseJson;
    var response;
    return Stream.fromFuture(
      SharedPreferences.getInstance().then(
        (value){
          response = value.getString("favoriteAlbums") as String;
          responseJson = jsonDecode( response);
          albumsFavorites = responseJson.map((element) => 
            AlbumFavoriteStatus.fromJson(element)).toList();
          print("Getting favorite");
          print(albumsFavorites.first.favoriteStatus);
          return albumsFavorites;
        }
     )
    );
  }

  void setFavorites(List<AlbumFavoriteStatus> albums){
    SharedPreferences.getInstance().then(
      (value){
        print("settingFavorites");
        print(albums.first.favoriteStatus);
        String jsonData = jsonEncode(
          albums.map((album){
            return {
              "id": album.id,
              "isFavorite": album.favoriteStatus,
            };
          }).toList()
        );
        value.setString("favoriteAlbums", jsonData);
        return value;
      }
    );
  }

  Stream<List<Album>> getAlbums (){
    List<Album> albumsList = [];
    List<dynamic> responseJson;
    var response;
    return Stream.fromFuture(
      SharedPreferences.getInstance().then(
        (value){
          response = value.getString("albumsList") as String;
          responseJson = jsonDecode( response);
          albumsList = responseJson.map((element) => Album.fromJson(element)).toList();
          return albumsList;
        }
     )
    );
  }
  
  void setData(List<Album> albums){
    SharedPreferences.getInstance().then(
      (value){
        String jsonData = jsonEncode(
          albums.map((album){
            return {
              "id": album.id,
              "title": album.name,
              "userId": album.userId,
            };
          }).toList()
        );
        value.setString("albumsList", jsonData);
        return value;
      }
    );
  }
}