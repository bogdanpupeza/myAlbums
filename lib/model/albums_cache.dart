import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/albums.dart';

class AlbumsCache{
  final String _albumsCacheListKey = "albumsList";
  final String _dateKey = "dateKey";
  final String _favoritesKey = "favorites";


  Stream<List<Album>> getAlbums (){
    List<Album> albumsList = [];
    List<dynamic> responseJson;
    List<String> response;
    return Stream.fromFuture(
      SharedPreferences.getInstance().then(
        (value){
          response = value.getStringList(_albumsCacheListKey) as List<String>;
          albumsList = response.map((jsonAlbum){
              return Album.fromJson(jsonAlbum);
          }).toList();
          return albumsList;
        }
      )
    );
  }
  
  void setAlbums(List<Album> albums){
    SharedPreferences.getInstance().then(
      (value){
        List<String> jsonData =
          albums.map((album){
            return album.toJson();
          }).toList();
        value.setStringList(_albumsCacheListKey, jsonData);
        return value;
      }
    );
  }

  void setDate(DateTime dateTime){
    SharedPreferences.getInstance().then(
      (value){
        String jsonData = jsonEncode(
          dateTime.toIso8601String()
        );
        value.setString(_dateKey, jsonData);
        return value;
      }
    );
  }

  Stream<DateTime> getLastDate (){
    DateTime dateTime;
    List<dynamic> responseJson;
    var response;
    return Stream.fromFuture(
      SharedPreferences.getInstance().then(
        (value){
          response = value.getString(_dateKey) as String;
          responseJson = jsonDecode(response);
          dateTime = responseJson.map((e){
            return DateTime.parse(e);
          }).first;
          return dateTime;
        }
      )
    );
  }

  Stream<List<int>> getFavorites(){
    List<int> favorites = [];
    List<dynamic> responseJson;
    var response;
    return Stream.fromFuture(
      SharedPreferences.getInstance().then(
        (value){
          response = value.getString(_favoritesKey) as String;
          responseJson = jsonDecode( response);
          favorites = responseJson.map((element) => int.parse(element)).toList();
          return favorites;
        }
      )
    );
  }

  void setFavorites(List<int> favorites){

    SharedPreferences.getInstance().then(
      (value){
        String jsonData = jsonEncode(
          favorites.map((albumId){
            return {
              "id": albumId,
            };
          }).toList()
        );
        value.setString(_albumsCacheListKey, jsonData);
        return value;
      }
    );
  }

  
}
