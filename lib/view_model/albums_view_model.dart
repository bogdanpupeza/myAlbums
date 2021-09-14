import 'package:rxdart/rxdart.dart';

import '../model/albums_cache.dart';
import '../model/albums.dart';
import '../model/albums_repository.dart';
import '../model/albums_service.dart';


class AlbumsVM{
  final albumsRepository = AlbumsRepository(AlbumsService(),AlbumsCache());
  final Input input;
  late Output output;

  AlbumsVM(this.input){

    Stream<List<AlbumFavoriteStatus>>
    favoriteStream = input.favoriteToggle.flatMap(
      (chosenAlbum){
        return albumsRepository.toggleFavorite(chosenAlbum);
      }
    );

    Stream<AlbumsResponse> stream = input.loadData.flatMap(
      (event){
        return albumsRepository.getAlbums();
      }
    );
    output = Output(
      stream,
      favoriteStream,
    );
  }

  void toggle(int id){
    albumsRepository.toggleFavorite(id);
  }
}

class Input{
  Subject<bool> loadData;
  Subject<int> favoriteToggle;
  Input(
    this.loadData,
    this.favoriteToggle
  );
}

class Output{
  final Stream<AlbumsResponse> stream;
  final Stream<List<AlbumFavoriteStatus>> favoritesStream;
  Output(
    this.stream,
    this.favoritesStream,
  );
}