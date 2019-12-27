import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/EventProfile.dart';
import 'package:provider/provider.dart';
import '../controller/AuthController.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  Dio dio = new Dio();
  Future<User> user;
  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  Future<User> getUser() async {
    FirebaseUser user = await Provider.of<AuthController>(context).getUser();
    IdTokenResult token = await user.getIdToken();
    Response response = await dio.get(
      "https://justmeetgjj.herokuapp.com/user",
      options: Options(
        headers: {
          "Authorization": token.token,
        },
        responseType: ResponseType.json,
      ),
    );
    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    this.user = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF5257F2),
      child: FutureBuilder<User>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.events);
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ...snapshot.data.events.map((f) {
                    Event event = Event.fromJson(f);
                    return EventProfile(
                      event: event,
                    );
                  }),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
        future: user,
      ),
    );
  }
}
