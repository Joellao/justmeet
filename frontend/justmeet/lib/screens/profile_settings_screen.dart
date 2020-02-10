import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:justmeet/controller/UserController.dart';
import 'package:provider/provider.dart';

class ProfileSettingsScreen extends StatefulWidget {
  User user;

  ProfileSettingsScreen({Key key, this.user}) : super(key: key);
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  File _image;
  String userName, email, bio, imageUrl;
  final _formKey = GlobalKey<FormState>();

  TextEditingController controllerUsername;
  TextEditingController controllerBio;
  TextEditingController controllerEmail;
  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      editProfile();
    }
  }

  @override
  void initState() {
    super.initState();
    controllerUsername = new TextEditingController(text: widget.user.username);
    controllerBio = new TextEditingController(text: widget.user.bio);
    controllerEmail = new TextEditingController(text: widget.user.email);
    imageUrl = this.widget.user.profileImage;
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
          "https://justmeetgjj.herokuapp.com/user/${widget.user.uid}/uploadProfilePicutre",
          data: formData,
          options: Options(
            headers: {
              "Authorization": token,
            },
            responseType: ResponseType.json,
          ),
        );
        setState(() {
          imageUrl = response.data;
        });
      } on DioError catch (e) {
        print(e.response);
      }
    }
  }

  void editProfile() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context, listen: false);
        Response response = await dio.put(
          "https://justmeetgjj.herokuapp.com/user/${this.widget.user.uid}",
          data: {
            "username": userName,
            "bio": bio,
            "email": email,
            "profileImage":
                imageUrl != null ? imageUrl : widget.user.profileImage
          },
          options: Options(
            headers: {
              "Authorization": token,
            },
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          print(response.data);
          User userToChangeWith = User.fromJson(response.data);
          Provider.of<User>(context, listen: false).update(
              userToChangeWith.uid,
              userToChangeWith.firstName,
              userToChangeWith.lastName,
              userToChangeWith.birthDate,
              userToChangeWith.email,
              userToChangeWith.bio,
              userToChangeWith.events,
              userToChangeWith.profileImage,
              userToChangeWith.username,
              userToChangeWith.announcements,
              userToChangeWith.friends,
              userToChangeWith.friendRequests,
              userToChangeWith.partecipatedEvents);
          print("Profilo modificato");
          var count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
        }
      } on DioError catch (e) {
        print(e.response);
      }
    }
  }

  void signOut() async {
    final auth = Provider.of<AuthController>(context, listen: false);
    await auth.signOut();
    Navigator.popUntil(context, (asd) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Impostazioni"),
        centerTitle: true,
        backgroundColor: Colori.bluScuro,
        elevation: 1,
        actions: <Widget>[
          InkWell(
            onTap: signOut,
            child: Icon(
              Icons.exit_to_app,
              size: 30.0,
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colori.bluScuro,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                InkWell(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage:
                        imageUrl != "" ? NetworkImage(imageUrl) : null,
                    child: imageUrl == "" ? Icon(Icons.person, size: 70) : null,
                  ),
                ),
                Form(
                  key: this._formKey,
                  child: Column(
                    children: <Widget>[
                      CustomField(
                        controller: controllerUsername,
                        icon: Icons.person,
                        label: 'Username',
                        hint: 'Inserisci username',
                        validator: (name) => null,
                        onSaved: (userName) => this.userName = userName,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      CustomField(
                        controller: controllerBio,
                        icon: Icons.create,
                        label: 'Bio',
                        hint: 'Inserisci la bio',
                        validator: (bio) => null,
                        onSaved: (bio) => this.bio = bio,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      CustomField(
                        controller: controllerEmail,
                        icon: Icons.email,
                        label: 'Email',
                        hint: 'Inserisci la tua nuova email',
                        validator: (email) {
                          if (email.isEmpty) {
                            return "L'email non può essere vuoto";
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email);
                          if (!emailValid) {
                            return "Non è un email valido";
                          }
                          return null;
                        },
                        onSaved: (email) => this.email = email,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      FlatButton(
                        color: Colori.viola,
                        padding: EdgeInsets.symmetric(
                          horizontal: 70.0,
                        ),
                        onPressed: _submit,
                        child: Text(
                          "Salva",
                          style: TextStyle(
                            color: Colori.grigio,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
