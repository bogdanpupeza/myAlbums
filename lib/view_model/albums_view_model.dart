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
    Stream<AlbumsResponse> stream = input.loadData.flatMap(
      (event){
        return albumsRepository.getAlbums();
      }
    );
    output = Output(stream);
  }
}

class Input{
  Subject<bool> loadData;
  Input(this.loadData);
}

class Output{
  final Stream<AlbumsResponse> stream;
  Output(this.stream);
}