import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class RequestWidget extends StatefulWidget {
  final User user;

  //final Widget profileWidget;

  const RequestWidget({Key key, this.user}) : super(key: key);
  @override
  _RequestWidgetState createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  Dio dio = new Dio();

  _accept() async {
    try {
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.patch(
        "https://justmeetgjj.herokuapp.com/user/${this.widget.user.uid}/true",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        if (response.data) {
          print("Richiesta accettata");
        } else {
          print("errore");
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }
  }

  _refuse() async {
    try {
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.patch(
        "https://justmeetgjj.herokuapp.com/user/${this.widget.user.uid}/false",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        if (response.data) {
          print("Richiesta rifiutata");
        } else {
          print("errore");
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }
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
                    onPressed: () {
                      if (_accept() != null) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Hai stretto amicizia"),
                        ));
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
                    onPressed: () {
                      if (_refuse() != null) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Hai rifiutato la richiesta"),
                        ));
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
