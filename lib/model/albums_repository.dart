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

  Stream<AlbumsResponse> getAlbums(){
    Stream<List<Album>> albumsStream = Stream.fromFuture(
      albumsService.getAlbums().then(
        (albums){
          _lastUpdate = DateTime.now();
          albumsCache.setData(albums);
          return albums;
        }
      ).onError(
        (error, stackTrace){
          return albumsCache.getAlbums();
        })
    );
    return albumsStream.map((albumsList){
        return AlbumsResponse(albums: albumsList, lastUpdate: _lastUpdate);
      });
  }
}