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
  
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int?,
      name: json['title'] as String?,
      userId: json['userId'] as int?,
      favorite: json['favoriteStatus'] as bool?,
    );
  }

  Map<String, dynamic >toJson(){
    return {
      "id": id,
      "title": name,
      "userId": userId,
      "favoriteStatus": favorite,
      
    };
  }
}

class AlbumsResponse{
  final List<Album> albums;
  DateTime? lastUpdate;
  bool? liveUpdate;
  AlbumsResponse({
    required this.albums,
    required this.lastUpdate,
    required this.liveUpdate,
  });
  factory AlbumsResponse.fromAlbums(albums, date, liveUpdate){
    return AlbumsResponse(
      albums: albums,
      lastUpdate: date,
      liveUpdate: liveUpdate,
    );
  }
}
