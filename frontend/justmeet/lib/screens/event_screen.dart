import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/comment.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/comment_widget.dart';
import 'package:justmeet/screens/edit_event_screen.dart';
import 'package:justmeet/screens/photo_screen.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:justmeet/screens/review_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  const EventScreen({Key key, this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  static Future<void> openMap(String location) async {
    String result = location.replaceAll(RegExp(' '), '+');
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$result';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  final _formKey = GlobalKey<FormState>();
  String _body;
  _deleteEvent() async {
    print("Entrato");
    try {
      Dio dio = new Dio();
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.delete(
        "https://justmeetgjj.herokuapp.com/event/${this.widget.event.id}",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);
        print("Evento cancellato");
      }
    } on DioError catch (e) {
      print(e.response);
    }
  }

  _cancelEvent() async {
    print("Entrato");
    try {
      Dio dio = new Dio();
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.patch(
        "https://justmeetgjj.herokuapp.com/event/${this.widget.event.id}",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);
        print("Evento annullato");
      }
    } on DioError catch (e) {
      print(e.response);
    }
  }

  _submit() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_body);
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context, listen: false);
        Response response = await dio.post(
          "https://justmeetgjj.herokuapp.com/event/${this.widget.event.id}/comment",
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
          user.uid == this.widget.event.user.uid
              ? PopupMenuButton<int>(
                  icon: Icon(
                    Icons.settings,
                    size: 30.0,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: InkWell(
                        child: Text("Modifica Evento"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditEventScreen(
                                      event: this.widget.event)));
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: InkWell(
                        child: Text("Cancella Evento"),
                        onTap: () {
                          if (_deleteEvent() != null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Evento cancellato"),
                            ));
                          }
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: InkWell(
                        child: Text("Annulla Evento"),
                        onTap: () {
                          if (_cancelEvent() != null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Evento annullato"),
                            ));
                          }
                        },
                      ),
                    ),
                  ],
                )
              : Text(""),
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
                this.widget.event.cancelled
                    ? Text(
                        "EVENTO ANNULLATO!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 1,
                      ),
                Text(
                  this.widget.event.name,
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
                  this.widget.event.description,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 25,
                      color: Colori.grigio,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () => openMap(widget.event.location),
                      child: Icon(
                        Icons.location_on,
                        color: Colori.grigio,
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      this.widget.event.location,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colori.grigio,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  this.widget.event.date,
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
                  height: 20,
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
                      this.widget.event.category,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 25,
                          color: Colori.grigio,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      this.widget.event.isFree
                          ? Icons.money_off
                          : Icons.monetization_on,
                      color: Colori.grigio,
                      size: 40,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: 85,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colori.grigio, width: 1.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Partecipanti",
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: Colori.grigio,
                                ),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                widget.event.partecipants == null
                                    ? 0.toString()
                                    : widget.event.partecipants.length
                                        .toString(),
                                style: TextStyle(
                                  color: Colori.grigio,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 85,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colori.grigio, width: 1.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Rimasti",
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: Colori.grigio,
                                ),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                (widget.event.maxNumber -
                                        (widget.event.partecipants == null
                                            ? 0
                                            : widget.event.partecipants.length))
                                    .toString(),
                                style: TextStyle(
                                  color: Colori.grigio,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PhotoScreen(event: this.widget.event),
                        ),
                      ),
                      child: Icon(
                        Icons.photo,
                        size: 80,
                        color: Colori.grigio,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReviewScreen(event: this.widget.event),
                    ),
                  ),
                  child: Icon(
                    Icons.star,
                    size: 80,
                    color: Colori.grigio,
                  ),
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
                  children:
                      List.generate(this.widget.event.comments.length, (index) {
                    Comment com = Comment.fromJson(
                        this.widget.event.comments.elementAt(index));
                    return CommentWidget(
                      comment: com,
                      profileWidget: getProfileWidget(this.widget.event),
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

  Widget getProfileWidget(Event event) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: event.user)),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: event.user.profileImage != ""
                      ? NetworkImage(event.user.profileImage)
                      : null,
                  child: event.user.profileImage == ""
                      ? Icon(Icons.person, size: 25)
                      : null,
                ),
                SizedBox(
                  width: 7.0,
                ),
                Text(
                  event.user.firstName,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  event.user.lastName,
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
