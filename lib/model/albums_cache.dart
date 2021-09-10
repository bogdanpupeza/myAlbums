import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/albums.dart';

class AlbumsCache{

  Future<List<Album>> getAlbums () async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Album> albumsList = [];
    List<dynamic> responseJson;
    try {
      responseJson = jsonDecode(pref.getString("data") as String);
      albumsList = responseJson.map((element) => Album.fromJson(element)).toList();
    } catch (error) {
      throw error;
    }
    return albumsList;
  }
  
  Future<void> setData(List<Album> albums) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    
    String jsonData = jsonEncode(
      albums.map((album){
        return {
          "id": album.id,
          "title": album.name,
          "userId": album.userId,
        };
      }).toList()
    );
    pref.setString("data", jsonData);
  }
}