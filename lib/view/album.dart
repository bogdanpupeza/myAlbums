import 'package:flutter/material.dart';


class AlbumWidget extends StatelessWidget {
  final String? name;
  final int? id;
  final int? userId;
  AlbumWidget({
    required this.name,
    required this.id,
    required this.userId,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
                    height: 90,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.amber,
                    ),
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        child: CircleAvatar(
                          child: Icon(Icons.image_rounded),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            alignment: Alignment.centerLeft,
                            height: 40,
                            child: Text(
                              name.toString(),
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              id.toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      )),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_right_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        onPressed: () {
                          // setState(() {
                          //   widget.isFavorite = !widget.isFavorite;
                          // });
                        },
                        icon: int.parse(userId.toString()) % 2 == 0
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                      ),
                    ]),
                  );
  }
}
