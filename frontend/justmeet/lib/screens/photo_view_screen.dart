import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  final String photoUrl;
  final String username;

  PhotoViewScreen({Key key, this.photoUrl, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colori.bluScuro,
        elevation: 1,
        title: Text(username),
        centerTitle: true,
      ),
      body: Container(
        color: Colori.bluScuro,
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: Colori.bluScuro),
          imageProvider: NetworkImage(photoUrl),
        ),
      ),
    );
  }
}
