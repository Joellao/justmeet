import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/widgets/event_widget.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Dio dio = new Dio();
  Future<List<Event>> events;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    events = getData();
  }

  Future<List<Event>> getData() async {
    String token = Provider.of<String>(context);
    Response response = await dio.get(
      "https://justmeetgjj.herokuapp.com/event/",
      options: Options(
        headers: {
          "Authorization": token,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<Event> events = [];
      List events2 = response.data;
      events2.forEach((event) {
        events.add(Event.fromJson(event));
      });
      return events;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colori.bluScuro,
      child: FutureBuilder<List<Event>>(
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Event event = snapshot.data.elementAt(index);
                return EventWidget(
                  event: event,
                  profileWidget: getProfileWidget(event),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
        future: events,
      ),
    );
  }

  Widget getProfileWidget(Event event) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
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
              Text(" "),
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
