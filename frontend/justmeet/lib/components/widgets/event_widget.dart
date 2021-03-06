import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/controller/EventController.dart';
import 'package:justmeet/controller/UserController.dart';
import 'package:justmeet/screens/event/event_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventWidget extends StatefulWidget {
  final Event event;
  final Widget profileWidget;

  const EventWidget({Key key, this.event, this.profileWidget})
      : super(key: key);
  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  Dio dio = new Dio();
  bool partecipating = false;
  int fake = 0;

  Future<bool> _partecipateFromProvider() async {
    String token = Provider.of<String>(context, listen: false);
    bool partecipate =
        await Provider.of<EventController>(context, listen: false)
            .partecipateEvent(token, this.widget.event.id);
    if (partecipate) {
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
      setState(() {
        partecipating = true;
        fake++;
      });
    }
    return partecipate;
  }

  Future<bool> _cancelPrenoteFromProvider() async {
    String token = Provider.of<String>(context, listen: false);
    bool cancelled = await Provider.of<EventController>(context, listen: false)
        .cancelPartecipateEvent(token, this.widget.event.id);
    if (cancelled) {
      var valore;
      this.widget.event.partecipants.forEach((value) {
        User user = User.fromJson(value);
        if (user.uid == Provider.of<User>(context, listen: false).uid) {
          valore = value;
        }
      });
      if (valore != null) {
        this.widget.event.partecipants.remove(valore);
      }
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
      setState(() {
        partecipating = false;
        fake--;
      });
    }
    return cancelled;
  }

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

  void isPrenoted() {
    bool found = false;
    if (this.widget.event.partecipants == null) return;
    this.widget.event.partecipants.forEach((value) {
      User user = User.fromJson(value);
      if (user.uid == Provider.of<User>(context, listen: false).uid) {
        found = true;
      }
    });
    setState(() {
      partecipating = found;
      fake = this.widget.event.partecipants.length;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isPrenoted();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventScreen(
            event: this.widget.event,
          ),
        ),
      ),
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
              widget.profileWidget != null ? widget.profileWidget : SizedBox(),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        "https://apprecs.org/ios/images/app-icons/256/ca/644106186.jpg",
                        height: 90,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.event.name,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.event.location,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          widget.event.date,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () => openMap(widget.event.location),
                              child: Icon(
                                Icons.directions,
                                size: 40,
                                color: Color(0xFF02020a),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xFF695E6C), width: 1.5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Totali",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Color(0xFF695E6C),
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              widget.event.maxNumber.toString(),
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xFF695E6C), width: 1.5),
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
                                color: Color(0xFF695E6C),
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              (widget.event.maxNumber - fake).toString(),
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Provider.of<User>(context, listen: false).uid !=
                              this.widget.event.user.uid
                          ? (partecipating)
                              ? RaisedButton(
                                  color: Colors.red,
                                  elevation: 4,
                                  disabledColor: Colors.red,
                                  child: Text(
                                    "Sprenotati",
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    bool cancel =
                                        await _cancelPrenoteFromProvider();
                                    if (cancel) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Sprenotazione effettuata"),
                                      ));
                                    }
                                  })
                              : Builder(
                                  builder: (context) => RaisedButton(
                                    color: Color(0xFF5257f2),
                                    elevation: 4,
                                    disabledColor: Colors.red,
                                    child: Text(
                                      "Prenotati",
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    onPressed: ((widget.event.maxNumber -
                                                (this
                                                            .widget
                                                            .event
                                                            .partecipants ==
                                                        null
                                                    ? 0
                                                    : this
                                                        .widget
                                                        .event
                                                        .partecipants
                                                        .length)) >
                                            0)
                                        ? () async {
                                            bool partecipate =
                                                await _partecipateFromProvider();
                                            if (partecipate) {
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Prenotazione effettuata"),
                                              ));
                                            }
                                          }
                                        : Text(""),
                                  ),
                                )
                          : Text(""),
                    ),
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
