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
    var response;
    return Stream.fromFuture(
      SharedPreferences.getInstance().then(
        (pref){
          response = pref.getString(_albumsCacheListKey) as String;
          responseJson = jsonDecode( response);
          albumsList = responseJson.map((element) => Album.fromJson(element)).toList();
          return albumsList;
        }
      ).onError((error, stackTrace){
        throw Error(); 
      })
    );
  }
  
  void setAlbums(List<Album> albums){
    SharedPreferences.getInstance().then(
      (pref){
        String jsonData = jsonEncode(
          albums.map((album){
            return album.toJson();
          }).toList()
        );
        pref.setString(_albumsCacheListKey, jsonData);
      }
    );
  }

  void setDate(DateTime dateTime){
    SharedPreferences.getInstance().then(
      (pref){
        String dateString = dateTime.toIso8601String();
        pref.setString(_dateKey, dateString);
      }
    );
  }

  Stream<DateTime?> getLastDate (){
    DateTime? dateTime;
    String dateString;
    return Stream.fromFuture(
      SharedPreferences.getInstance().then(
        (pref){
          dateString = pref.getString(_dateKey) as String;
          dateTime = DateTime.parse(dateString);
          return dateTime;
        }
      ).onError((error, stackTrace){
        return null;
      })
    );
  }

  Stream<List<int>> getFavorites(){
    List<int> favorites = [];
    List<String> response;
    return Stream.fromFuture(
      SharedPreferences.getInstance().then(
        (pref){
          response = pref.getStringList(_favoritesKey) as List<String>;
          favorites = response.map((idString){
            return int.parse(idString);
          }).toList();
          return favorites;
        }
      ).onError((error, stackTrace){
        throw Error();
      })
    );
  }

  void setFavorites(List<int> favorites){
    SharedPreferences.getInstance().then(
      (pref){
        List<String> ids =
          favorites.map((albumId){
            return albumId.toString();
          }).toList();
        pref.setStringList(_favoritesKey, ids);
      }
    );
  }

  
}
