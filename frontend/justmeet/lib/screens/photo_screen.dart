import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/event_photo.dart';
import 'package:justmeet/screens/photo_view_screen.dart';
import 'package:provider/provider.dart';

class PhotoScreen extends StatefulWidget {
  final Event event;
  const PhotoScreen({Key key, this.event}) : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  File _image;
  String imageUrl;

  void _delete(id) async {
    try {
      Dio dio = new Dio();
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.delete(
        "https://justmeetgjj.herokuapp.com/photo/$id",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      var valore;
      this.widget.event.photo.forEach((value) {
        EventPhoto photo = EventPhoto.fromJson(value);
        if (photo.id == id) {
          valore = value;
        }
      });
      this.widget.event.photo.remove(valore);

      print(response.data);
      setState(() {
        imageUrl = "photo.url";
      });
    } on DioError catch (e) {
      print(e.response);
    }
  }

  void getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    if (_image != null) {
      FormData formData = new FormData.fromMap({
        "photo": await MultipartFile.fromFile(_image.path,
            filename: _image.path.split("/").last),
      });
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context, listen: false);
        Response response = await dio.post(
          "https://justmeetgjj.herokuapp.com/event/${widget.event.id}/photo",
          data: formData,
          options: Options(
            headers: {
              "Authorization": token,
            },
            responseType: ResponseType.json,
          ),
        );
        EventPhoto photo = EventPhoto.fromJson(response.data);
        this.widget.event.photo.add(response.data);
        setState(() {
          imageUrl = photo.url;
        });
      } on DioError catch (e) {
        print(e.response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Foto ${this.widget.event.name}'),
        centerTitle: true,
        backgroundColor: Colori.bluScuro,
        actions: <Widget>[
          InkWell(
            onTap: getImage,
            child: Icon(Icons.add_photo_alternate),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        color: Colori.bluScuro,
        child: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(this.widget.event.photo.length, (index) {
            EventPhoto photo =
                EventPhoto.fromJson(this.widget.event.photo.elementAt(index));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhotoViewScreen(
                              photoUrl: photo.url,
                              username: photo.user.username,
                            )),
                  ),
                  onLongPress: () {
                    _delete(photo.id);
                  },
                  child: Image.network(
                    photo.url,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
