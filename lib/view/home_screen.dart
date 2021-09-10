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

class _HomeScreenState extends State<HomeScreen> {
  AlbumsVM albumsVM = AlbumsVM(
    Input(BehaviorSubject<bool>()),
  );
  void getAlbums() {
    setState(() {
      albumsVM.input.loadData.add(true);
    });
  }
  @override
  void initState() {
    super.initState();
    getAlbums();
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

                if(snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(),);
                else{
                if(snapshot.data != null){
                  var data = snapshot.data as AlbumsResponse;
                  var albums = data.albums;
                  var lastUpdate = data.lastUpdate;
                  //var difference = lastUpdate.difference(DateTime.now());
                return Column(
                  children: [
                    if(lastUpdate != null)
                    Text(
                      "Last update at: ${(DateFormat.Hms().format(lastUpdate))}"
                    ),
                    // if(lastUpdate == null)
                    // Text(
                    //   "Last update at: ${(DateFormat.Hms().format(lastUpdate))}"
                    // ),
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
                  return (Text("${(snapshot)}"));
              }
              }
              ),
          //insert a better function:
          onDoubleTap: getAlbums,

        ),
      ),
    );
  }
}
