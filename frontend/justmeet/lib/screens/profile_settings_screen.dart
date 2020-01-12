import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/controller/UserController.dart';
import 'package:provider/provider.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final User user;

  const ProfileSettingsScreen({Key key, this.user}) : super(key: key);
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    if (image != null) {
      FormData formData = new FormData.fromMap({
        "photo": _image,
      });
      Dio dio = new Dio();
      Response response = await dio.post(
          "https://justmeetgjj.herokuapp.com/user/${widget.user.uid}/uploadProfilePicutre",
          data: formData);
      String imageUrl = response.data;
      Provider.of<UserController>(context).modifyUser(
          context,
          widget.user.username,
          imageUrl,
          widget.user.bio,
          widget.user.email,
          widget.user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        backgroundColor: Colori.bluScuro,
        elevation: 1,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colori.bluScuro,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                onTap: getImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: widget.user.profileImage != ""
                      ? NetworkImage(widget.user.profileImage)
                      : null,
                  child: widget.user.profileImage == ""
                      ? Icon(Icons.person, size: 70)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
