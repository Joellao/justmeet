import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/event_widget.dart';
import 'package:justmeet/screens/profile_settings_screen.dart';
import 'package:provider/provider.dart';
import '../controller/AuthController.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  Dio dio = new Dio();
  User user;
  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  User getUser() {
    User user = Provider.of<User>(context);
    return user;
  }

  void signOut() async {
    final auth = Provider.of<AuthController>(context);
    await auth.signOut();
    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    this.user = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colori.bluScuro,
        elevation: 1,
        title: Text(user.firstName + " " + user.lastName),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileSettingsScreen(user: user)),
              );
            },
            child: Icon(
              Icons.settings,
              size: 30.0,
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: Container(
        color: Colori.bluScuro,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                backgroundImage: user.profileImage != ""
                    ? NetworkImage(user.profileImage)
                    : null,
                child: user.profileImage == ""
                    ? Icon(Icons.person, size: 70)
                    : null,
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: user.events.length,
                itemBuilder: (BuildContext context, int index) {
                  Event event = Event.fromJson(user.events.elementAt(0));
                  return EventWidget(
                    event: event,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
