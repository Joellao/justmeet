import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/models/comment.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/controller/CommentController.dart';
import 'package:justmeet/screens/comment/edit_comment_screen.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:justmeet/screens/comment/segnala_commento_screen.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final Widget profileWidget;
  final int index;
  final Function removeFunc;
  final Function modifyFunc;

  const CommentWidget(
      {Key key,
      this.comment,
      this.profileWidget,
      this.index,
      this.removeFunc,
      this.modifyFunc})
      : super(key: key);
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  Future<bool> _deleteCommentFromProvider() async {
    String token = Provider.of<String>(context, listen: false);
    bool deleted = await Provider.of<CommentController>(context, listen: false)
        .deleteComment(token, this.widget.comment.id);
    return deleted;
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
                                        builder: (context) => EditCommentScreen(
                                          comment: this.widget.comment,
                                          modifyFunc: this.widget.modifyFunc,
                                          index: this.widget.index,
                                        ),
                                      ));
                                },
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: InkWell(
                                child: Text("Cancella commento"),
                                onTap: () async {
                                  bool delete =
                                      await _deleteCommentFromProvider();
                                  if (delete) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Commento cancellato"),
                                    ));
                                    this
                                        .widget
                                        .removeFunc(true, this.widget.index);
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
