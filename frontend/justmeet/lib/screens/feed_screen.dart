import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/announcement.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/announcement_widget.dart';
import 'package:justmeet/components/widgets/event_widget.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Dio dio = new Dio();
  Future<List<dynamic>> robe;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    robe = getDataEvent();
  }

  Future<List<dynamic>> getDataEvent() async {
    String token = Provider.of<String>(context);
    Response response = await dio.get(
      "https://justmeetgjj.herokuapp.com/feed/",
      options: Options(
        headers: {
          "Authorization": token,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> robe = [];
      List robe2 = response.data;
      robe2.forEach((robbo) {
        if (robbo['location'] != null) {
          robe.add(Event.fromJson(robbo));
        } else {
          robe.add(Announcement.fromJson(robbo));
        }
        ;
      });

      return robe;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colori.bluScuro,
      child: FutureBuilder<List<dynamic>>(
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var event = snapshot.data.elementAt(index);
                if (event is Event)
                  return EventWidget(
                    event: event,
                    profileWidget: getProfileWidget(event),
                  );
                else
                  return AnnouncementWidget(
                    announcement: event,
                  );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
        future: robe,
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
