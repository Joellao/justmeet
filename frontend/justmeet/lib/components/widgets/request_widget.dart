import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/controller/UserController.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class RequestWidget extends StatefulWidget {
  final User user;
  final int index;
  final Function func;

  //final Widget profileWidget;

  const RequestWidget({Key key, this.user, this.index, this.func})
      : super(key: key);
  @override
  _RequestWidgetState createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  Dio dio = new Dio();

  Future<bool> _acceptFromProvider() async {
    String token = Provider.of<String>(context, listen: false);
    bool accept = await Provider.of<UserController>(context, listen: false)
        .acceptRequest(token, this.widget.user.uid);
    User user = await Provider.of<UserController>(context, listen: false)
        .getUser(context);
    Provider.of<User>(context, listen: false).update(
        user.uid,
        user.firstName,
        user.lastName,
        user.birthDate,
        user.email,
        user.bio,
        user.events,
        user.profileImage,
        user.username,
        user.announcements,
        user.friends,
        user.friendRequests,
        user.partecipatedEvents);
    return accept;
  }

  Future<bool> _refuseFromProvider() async {
    String token = Provider.of<String>(context, listen: false);
    bool accept = await Provider.of<UserController>(context, listen: false)
        .refuseRequest(token, this.widget.user.uid);
    User user = await Provider.of<UserController>(context, listen: false)
        .getUser(context);
    Provider.of<User>(context, listen: false).update(
        user.uid,
        user.firstName,
        user.lastName,
        user.birthDate,
        user.email,
        user.bio,
        user.events,
        user.profileImage,
        user.username,
        user.announcements,
        user.friends,
        user.friendRequests,
        user.partecipatedEvents);
    return accept;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Card(
          elevation: 4,
          color: Color(0XFFe1e2ef),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(user: this.widget.user)),
                      ),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: this.widget.user.profileImage != ""
                                ? NetworkImage(this.widget.user.profileImage)
                                : null,
                            child: this.widget.user.profileImage == ""
                                ? Icon(Icons.person,
                                    size: 25, color: Colori.grigio)
                                : null,
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          Text(
                            this.widget.user.firstName,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Colori.bluScuro,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(" "),
                          Text(
                            this.widget.user.lastName,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Colori.bluScuro,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xFF5257f2),
                    elevation: 4,
                    disabledColor: Colors.red,
                    child: Text(
                      "Accetta",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      bool result = await _acceptFromProvider();
                      if (result) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Hai stretto amicizia"),
                          ),
                        );
                        this.widget.func(true, this.widget.index);
                      }
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    color: Color(0xFF5257f2),
                    elevation: 4,
                    disabledColor: Colors.red,
                    child: Text(
                      "Rifiuta",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      bool result = await _refuseFromProvider();
                      if (result) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Hai rifiutato la richiesta"),
                          ),
                        );
                        this.widget.func(true, this.widget.index);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
