import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/models/comment.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/screens/edit_comment_screen.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:justmeet/screens/segnala_commento_screen.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final Widget profileWidget;
  final int index;
  final Function func;

  const CommentWidget(
      {Key key, this.comment, this.profileWidget, this.index, this.func})
      : super(key: key);
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  Future<bool> _deleteComment() async {
    try {
      Dio dio = new Dio();
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.delete(
        "https://justmeetgjj.herokuapp.com/comment/${this.widget.comment.id}",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);
        print("Segnalato con successo");
        return true;
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return false;
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
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(user: this.widget.comment.user)),
                      ),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:
                                this.widget.comment.user.profileImage != ""
                                    ? NetworkImage(
                                        this.widget.comment.user.profileImage)
                                    : null,
                            child: this.widget.comment.user.profileImage == ""
                                ? Icon(Icons.person, size: 25)
                                : null,
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          Text(
                            this.widget.comment.user.firstName,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(" "),
                          Text(
                            this.widget.comment.user.lastName,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<int>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 30.0,
                      ),
                      itemBuilder: (context) {
                        if (Provider.of<User>(context, listen: false).uid ==
                            this.widget.comment.user.uid) {
                          return [
                            PopupMenuItem(
                              value: 1,
                              child: InkWell(
                                child: Text("Modifica commento"),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditCommentScreen(
                                                  comment:
                                                      this.widget.comment)));
                                },
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: InkWell(
                                child: Text("Cancella commento"),
                                onTap: () async {
                                  bool delete = await _deleteComment();
                                  if (delete) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Commento cancellato"),
                                    ));
                                    this.widget.func(true, this.widget.index);
                                  }
                                },
                              ),
                            ),
                          ];
                        } else {
                          return [
                            PopupMenuItem(
                              value: 3,
                              child: InkWell(
                                child: Text("Segnala commento"),
                                onTap: () {
                                  print("entrato");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportCommentScreen(
                                          commentId: this.widget.comment.id),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ];
                        }
                      },
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 10),
                          Text(
                            this.widget.comment.date,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.comment.body,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ]),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
