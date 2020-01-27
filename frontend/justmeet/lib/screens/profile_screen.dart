import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/screens/my_friends.dart';
import 'package:justmeet/screens/profile_announcement_screen.dart';
import 'package:justmeet/screens/profile_event_screen.dart';
import 'package:justmeet/screens/profile_settings_screen.dart';
import 'package:justmeet/screens/request_friends.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  Dio dio = new Dio();

  TabController controller;

  _sendFriendRequest() async {
    try {
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.patch(
        "https://justmeetgjj.herokuapp.com/user/${this.widget.user.uid}",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        if (response.data) {
          print("Richiesta mandata con successo");
        } else {
          print("Richiesta non mandata con successo");
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }
  }

  _removeFriend() async {
    try {
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.put(
        "https://justmeetgjj.herokuapp.com/user/${this.widget.user.uid}/removeFriend",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        if (response.data) {
          print("Richiesta mandata con successo");
        } else {
          print("Richiesta non mandata con successo");
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }
  }

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool getFriendRequest() {
    List friendRequests = this.widget.user.friendRequests;
    List<dynamic> robe = [];
    print(friendRequests);
    friendRequests.forEach((robbo) {
      User user = User.fromJson(robbo);
      robe.add(user.uid);
    });
    return robe.contains(Provider.of<User>(context).uid);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // This is the number of tabs.
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                backgroundColor: Colori.bluScuro,
                pinned: true,
                title: Text(this.widget.user.username),
                centerTitle: true,
                actions: <Widget>[
                  Provider.of<User>(context).uid == this.widget.user.uid
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileSettingsScreen(
                                      user: this.widget.user)),
                            );
                          },
                          child: Icon(
                            Icons.settings,
                            size: 30.0,
                          ),
                        )
                      : !getFriendRequest()
                          ? InkWell(
                              onTap: () {
                                _sendFriendRequest();
                              },
                              child: Icon(
                                Icons.person_add,
                                size: 30.0,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                _sendFriendRequest();
                              },
                              child: Icon(
                                Icons.remove_circle,
                                size: 30.0,
                              ),
                            ),
                  SizedBox(width: 10)
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: this.widget.user.profileImage != ""
                      ? Image.network(
                          this.widget.user.profileImage,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person_outline,
                          color: Colori.grigio,
                          size: 135,
                        ),
                ),
                expandedHeight: 250.0,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  tabs: [
                    Tab(child: Text("Eventi")),
                    Tab(child: Text("Annunci")),
                    Tab(child: Text("Amici")),
                    Tab(child: Text("Richieste"))
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: [
              ProfileEventScreen(
                events: this.widget.user.events,
              ),
              ProfileAnnouncementScreen(
                announcements: this.widget.user.announcements,
              ),
              MyFriendsScreen(friends: this.widget.user.friends),
              RequestFriendsScreen(requests: this.widget.user.friendRequests),
            ]),
      ),
    );
  }
}
