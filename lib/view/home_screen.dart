import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/view/album.dart';
import 'package:my_albums6/view_model/albums_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AlbumsVM albumsVM = AlbumsVM(
    Input(BehaviorSubject<bool>()),
  );
  void getAlbums() {
    print("AA");
    setState(() {
      albumsVM.input.loadData.add(true);
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
          child: StreamBuilder(
              stream: albumsVM.output.stream,
              builder: (ctx, snapshot) {
                if(snapshot.data != null){
                  var data = snapshot.data as AlbumsResponse;
                  var albums = data.albums;
                  var lastUpdate = data.lastUpdate;
                  var difference = lastUpdate.difference(DateTime.now());
                return snapshot.connectionState == ConnectionState.waiting
                ?  Center(child: CircularProgressIndicator(),)
                :  Column(
                  children: [
                    Text(
                      "Last update at: ${(DateFormat.Hms().format(lastUpdate))}"
                    ),
                    Expanded(
                      //height: 640,
                      child: ListView.builder(
                        itemCount: albums.length,
                        itemBuilder: (ctx, index) {
                          return AlbumWidget(
                            name: albums[index].name,
                            id: albums[index].id,
                            userId: albums[index].userId,
                          );
                        },
    
                      ),
                    ),
                  ],
                );
                }
                else
                  return (Text("Double Tap for Updates"));
              }),
          //insert a better function:
          onDoubleTap: getAlbums,

        ),
      ),
    );
  }
}
