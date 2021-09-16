import 'dart:convert';

class Album{
  final int? userId;
  final String? name;
  final int? id;
  bool? favorite;
  Album({
    required this.userId,
    required this.name,
    required this.id,
    this.favorite = false,
  });
  
  factory Album.fromJson(String jsonString) {
    dynamic jsonAlbum = json.decode(jsonString);
    return Album(
      id: jsonAlbum['id'] as int?,
      name: jsonAlbum['title'] as String?,
      userId: jsonAlbum['userId'] as int?,
      favorite: jsonAlbum['favoriteStatus'] as bool?,
    );
  }

  String toJson(){
    return json.encode({
      "id": id,
      "title": name,
      "userId": userId,
      "favoriteStatus": favorite,
    });
  }
}

class AlbumsResponse{
  final List<Album> albums;
  DateTime? lastUpdate;
  AlbumsResponse({
    required this.albums,
    required this.lastUpdate,
  });
  factory AlbumsResponse.fromAlbums(albums, date){
    return AlbumsResponse(
      albums: albums,
      lastUpdate: date,
    );
  }
}
