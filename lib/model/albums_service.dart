import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/albums.dart';

class AlbumsService {
  String _url = "https://jsonplaceholder.typicode.com/albums";
  Future<List<Album>> getAlbums () async {
    List<dynamic> responseJson;
    List<Album> albums = [];
    try {
      var response = await http.get(Uri.parse(_url));
        responseJson = jsonDecode(response.body);
        albums = responseJson.map((element) {
          return Album.fromJson(element);
        }).toList();
    } on SocketException{
      throw SocketException("No interner connection");
    } catch (error) {
      throw error;
    }
    return albums;
  }
}