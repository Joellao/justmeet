import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/announcement.dart';
import 'package:justmeet/components/models/comment.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/comment_widget.dart';
import 'package:justmeet/controller/AnnouncementController.dart';
import 'package:justmeet/screens/announcement/edit_annnouncement_screen.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class AnnouncementScreen extends StatefulWidget {
  Announcement announce;

  AnnouncementScreen({Key key, this.announce}) : super(key: key);

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  String _body;

  bool refresh;

  remove(value, index) {
    this.widget.announce.comments.removeAt(index);
    setState(() {
      refresh = value;
    });
  }

  add(value, comment) {
    this.widget.announce.comments.add(comment);
    setState(() {
      refresh = value;
    });
  }

  replaceComment(value, comment, index) {
    this.widget.announce.comments.removeAt(index);
    this.widget.announce.comments.insert(index, comment);
    setState(() {
      refresh = value;
    });
  }

  modifyAnnounce(value, announce) {
    this.widget.announce = Announcement.fromJson(announce);
    setState(() {
      refresh = value;
    });
  }

  Future<bool> _deleteFromProvider() async {
    String token = Provider.of<String>(context, listen: false);
    bool deleted =
        await Provider.of<AnnouncementController>(context, listen: false)
            .deleteAnnouncement(token, this.widget.announce.id);
    if (deleted) {
      List announces = [];
      User user = Provider.of<User>(context, listen: false);
      for (Map<String, dynamic> announce in user.announcements) {
        Announcement a = Announcement.fromJson(announce);
        if (a.id != this.widget.announce.id) {
          announces.add(announce);
        }
      }
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
          announces,
          user.friends,
          user.friendRequests,
          user.partecipatedEvents);
      var count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    }
    return deleted;
  }

  Future<LinkedHashMap<String, dynamic>> _createCommentFromProvider() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String token = Provider.of<String>(context, listen: false);
      return await Provider.of<AnnouncementController>(context, listen: false)
          .commentAnnouncement(token, this.widget.announce.id, this._body);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colori.bluScuro,
        actions: <Widget>[
          user.uid == this.widget.announce.user.uid
              ? PopupMenuButton<int>(
                  icon: Icon(
                    Icons.settings,
                    size: 30.0,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: InkWell(
                        child: Text("Modifica Annuncio"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAnnouncementScreen(
                                announce: this.widget.announce,
                                func: this.modifyAnnounce,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: InkWell(
                        child: Text("Cancella Annuncio"),
                        onTap: () async {
                          bool delete = await _deleteFromProvider();
                          if (delete) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Annuncio cancellato"),
                              ),
                            );
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "C'è stato un errore, riprova più tardi"),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                )
              : Text(
                  "",
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  this.widget.announce.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 25,
                      color: Colori.grigio,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  this.widget.announce.description,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 25,
                      color: Colori.grigio,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.category,
                      color: Colori.grigio,
                      size: 40,
                    ),
                    SizedBox(width: 20),
                    Text(
                      this.widget.announce.category,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 25,
                          color: Colori.grigio,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: CustomField(
                    icon: Icons.comment,
                    label: '',
                    hint: "Commenta l'evento",
                    validator: (name) => name.length <= 0
                        ? 'Il commento non può essere vuoto'
                        : null,
                    onSaved: (name) => this._body = name,
                    obscureText: false,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    LinkedHashMap comment = await _createCommentFromProvider();
                    add(true, comment);
                  },
                  child: Icon(
                    Icons.send,
                    color: Colori.grigio,
                    size: 40,
                  ),
                ),
                Column(
                  children: List.generate(this.widget.announce.comments.length,
                      (index) {
                    Comment com = Comment.fromJson(
                        this.widget.announce.comments.elementAt(index));
                    return CommentWidget(
                        comment: com,
                        removeFunc: remove,
                        modifyFunc: replaceComment,
                        index: index);
                  }),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getProfileWidget(Announcement announce) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: announce.user)),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: announce.user.profileImage != ""
                      ? NetworkImage(announce.user.profileImage)
                      : null,
                  child: announce.user.profileImage == ""
                      ? Icon(Icons.person, size: 25)
                      : null,
                ),
                SizedBox(
                  width: 7.0,
                ),
                Text(
                  announce.user.firstName,
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
                  announce.user.lastName,
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
          InkWell(
            onTap: () => print("More premuto"),
            child: Icon(
              Icons.more_vert,
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
