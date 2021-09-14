class Album{
  final int? userId;
  final String? name;
  final int? id;
  bool? favorite;
  Album({
    required this.userId,
    required this.name,
    required this.id,
    this.favorite
  });
  
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int?,
      name: json['title'] as String?,
      userId: json['userId'] as int?,
      favorite: false,
    );
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
//
class AlbumFavoriteStatus{
  final int? id;
  bool? favoriteStatus;
  AlbumFavoriteStatus({
    required this.id,
    required this.favoriteStatus,
  });
  factory AlbumFavoriteStatus.fromJson(Map<String, dynamic> json) {
    return AlbumFavoriteStatus(
      id: json['id'] as int,
      favoriteStatus: json["favoriteStatus"] as bool?,
    );
  }
}