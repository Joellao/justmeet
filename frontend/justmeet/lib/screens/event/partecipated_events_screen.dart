import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/event_widget.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class PartecipatedEventsScreen extends StatelessWidget {
  final List<dynamic> events;

  const PartecipatedEventsScreen({Key key, @required this.events})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colori.bluScuro,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              print(events.elementAt(index));
              var event = Event.fromJson(events.elementAt(index));
              return EventWidget(
                  event: event,
                  profileWidget: getProfileWidget(event.user, context));
            },
          ),
        ),
      ),
    );
  }

  Widget getProfileWidget(User u, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen(user: u)),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: u.profileImage != ""
                      ? NetworkImage(u.profileImage)
                      : null,
                  child: u.profileImage == ""
                      ? Icon(Icons.person, size: 25)
                      : null,
                ),
                SizedBox(
                  width: 7.0,
                ),
                Text(
                  u.firstName,
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
                  u.lastName,
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
        ],
      ),
    );
  }
}
