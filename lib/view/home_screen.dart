import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

import '../model/albums.dart';
import './album.dart';
import '../view_model/albums_view_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

extension on Duration{
  String get showLastUpdate{
    String duration = "";
    if(this.inDays > 0){
      duration += "${(this.inDays.toString())} days ";
    } else {
      if(this.inHours > 0) {
        int hours = this.inHours % 24;
        duration += "${(hours.toString())} hours ";
        if(this.inMinutes > 0){
          int minutes = this.inMinutes % 60;
          duration += "${(minutes.toString())} minutes ";
        }
      } else {
        if(this.inMinutes > 0){
          int minutes = this.inMinutes % 60;
          duration += "${(minutes.toString())} minutes ";
        }
        if(this.inSeconds >= 0){
          int seconds = this.inSeconds % 60;
          duration += "${(seconds.toString())} seconds";
        }
      }
    }
    return duration;
  }
}


class _HomeScreenState extends State<HomeScreen> {
  AlbumsVM albumsVM = AlbumsVM(
    Input(
      BehaviorSubject<bool>(),
      BehaviorSubject<int>(),
    ),
  );

  void getAlbums() {
   albumsVM.input.loadData.add(true);
  }


  void toggleFavorite(int albumId){
    albumsVM.input.toggleFavorite.add(albumId);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Albums"),
      ),
      body: Center(
        child: GestureDetector(
          child: StreamBuilder<AlbumsResponse>(
              stream: albumsVM.output.albumsDataStream,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  if (snapshot.data != null) {
                    var data = snapshot.data as AlbumsResponse;
                    var albums = data.albums;
                    var lastUpdate = data.lastUpdate;
                    Duration duration = Duration();
                    if(lastUpdate != null)
                      duration = DateTime.now().difference(lastUpdate);
                    return Column(
                      children: [
                        if (duration != null)
                          Text("Results updated ${(duration.showLastUpdate)} ago"),
                        Expanded(
                          child: ListView.builder(
                            itemCount: albums.length,
                            itemBuilder: (ctx, index) {
                              return AlbumWidget(
                                toggleFavorite: toggleFavorite,
                                isFavorite: albums[index].favorite,
                                name: albums[index].name,
                                id: albums[index].id,
                                userId: albums[index].userId,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else
                    return (Text("There are no albums"));
                }
              }),
          onDoubleTap: getAlbums,
        ),
      ),
    );
  }
}
