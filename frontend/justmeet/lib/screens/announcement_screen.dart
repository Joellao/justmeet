import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/announcement.dart';
import 'package:justmeet/components/models/comment.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/comment_widget.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class AnnouncementScreen extends StatefulWidget {
  final Announcement announce;

  const AnnouncementScreen({Key key, this.announce}) : super(key: key);

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  String _body;

  _submit() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_body);
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context);
        Response response = await dio.post(
          "https://justmeetgjj.herokuapp.com/announcement/${this.widget.announce.id}/comment",
          data: {
            "body": _body,
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
          print("Evento commentato");
        }
      } on DioError catch (e) {
        print(e.response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colori.bluScuro,
        actions: <Widget>[
          user.uid == this.widget.announce.user.uid
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => null));
                  },
                  child: Icon(
                    Icons.settings,
                    size: 30.0,
                  ),
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
                      fontWeight: FontWeight.bold,
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
                  onTap: () => _submit(),
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
                      profileWidget: getProfileWidget(this.widget.announce),
                    );
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
