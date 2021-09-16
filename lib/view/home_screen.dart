import 'package:flutter/material.dart';
import './date.dart';
import 'package:rxdart/rxdart.dart';

import '../model/albums.dart';
import './album.dart';
import '../view_model/albums_view_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AlbumsVM albumsVM = AlbumsVM(
    Input(
      BehaviorSubject<bool>(),
      BehaviorSubject<int>(),
    ),
  );
  void getAlbums() {
    setState(() {
      albumsVM.input.loadData.add(true);
    });
  }


  void toggleFavorite(int albumId){
    setState(() {
      albumsVM.input.toggleFavorite.add(albumId);
    });
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
                    AlbumsResponse data = snapshot.data as AlbumsResponse;
                    List<Album> albums = data.albums;
                    DateTime? lastUpdate = data.lastUpdate;
                    bool? liveUpdate = data.liveUpdate;
                    return Column(
                      children: [
                        DateWidget(
                          date: lastUpdate,
                          liveUpdate: liveUpdate,
                        ),
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
