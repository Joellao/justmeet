import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/screens/my_friends.dart';
import 'package:justmeet/screens/new_event_screen.dart';
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
  User utente;

  Future<User> getUser() async {
    String token = Provider.of<String>(context, listen: false);

    try {
      Response response = await dio.get(
        "https://justmeetgjj.herokuapp.com/user/${this.widget.user.uid}",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        if (response.data == "") return null;
        return User.fromJson(response.data);
      }
      if (response.statusCode == 500) {
        print("Ciao");
      }
    } on DioError catch (e) {}
    return null;
  }

  TabController controller;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  _sendFriendRequest() async {
    try {
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.patch(
        "https://justmeetgjj.herokuapp.com/user/${utente.uid}",
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
        "https://justmeetgjj.herokuapp.com/user/${utente.uid}/removeFriend",
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

  fetchUser() async {
    print("DIO DE DIO");
    if (Provider.of<User>(context, listen: false).uid == this.widget.user.uid) {
      setState(() {
        utente = this.widget.user;
      });
    } else {
      var user2 = await getUser();
      setState(() {
        utente = user2;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
    fetchUser();
  }

  bool getFriendRequest() {
    List friendRequests = utente.friendRequests;
    List<dynamic> robe = [];
    print(friendRequests);
    friendRequests.forEach((robbo) {
      User user = User.fromJson(robbo);
      robe.add(user.uid);
    });
    return robe.contains(Provider.of<User>(context).uid);
  }

  bool isMyFriend() {
    List myFriends = Provider.of<User>(context).friends;
    List<dynamic> robe = [];
    myFriends.forEach((robbo) {
      User user = User.fromJson(robbo);
      robe.add(user.uid);
    });
    return robe.contains(utente.uid);
  }

  @override
  Widget build(BuildContext context) {
    if (utente == null) {
      return Scaffold(
        body: Container(
          color: Colori.bluScuro,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    List<Tab> userTabs = [
      Tab(child: Text("Eventi")),
      Tab(child: Text("Annunci")),
      Tab(child: Text("Amici")),
      Tab(child: Text("Richieste"))
    ];
    List<Tab> otherUserTabs = [
      Tab(child: Text("Eventi")),
      Tab(child: Text("Annunci")),
      Tab(child: Text("Amici")),
    ];
    List<Tab> institutionTabs = [
      Tab(child: Text("Eventi")),
      Tab(child: Text("Crea Evento")),
    ];
    List<Tab> otherInstitutionTabs = [
      Tab(child: Text("Eventi")),
    ];
    List<Widget> userPages = [
      ProfileEventScreen(
        events: utente.events,
      ),
      ProfileAnnouncementScreen(
        announcements: utente.announcements,
      ),
      MyFriendsScreen(friends: utente.friends),
      RequestFriendsScreen(requests: utente.friendRequests),
    ];
    List<Widget> otherUserPages = [
      ProfileEventScreen(
        events: utente.events,
      ),
      ProfileAnnouncementScreen(
        announcements: utente.announcements,
      ),
      MyFriendsScreen(friends: utente.friends),
    ];
    List<Widget> insitutionPages = [
      ProfileEventScreen(
        events: utente.events,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 120),
        child: NewEventScreen(),
      )
    ];
    List<Widget> otherInsitutionPages = [
      ProfileEventScreen(
        events: utente.events,
      ),
    ];

    List<Tab> toUseTabs = utente.type == 1
        ? (Provider.of<User>(context).uid == utente.uid
            ? userTabs
            : otherUserTabs)
        : (Provider.of<User>(context).uid == utente.uid
            ? institutionTabs
            : otherInstitutionTabs);
    List<Widget> toUsePages = utente.type == 1
        ? (Provider.of<User>(context).uid == utente.uid
            ? userPages
            : otherUserPages)
        : (Provider.of<User>(context).uid == utente.uid
            ? insitutionPages
            : otherInsitutionPages);

    return DefaultTabController(
      length: toUseTabs.length, // This is the number of tabs.
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                backgroundColor: Colori.bluScuro,
                pinned: true,
                title: Text(utente.username),
                centerTitle: true,
                actions: <Widget>[
                  Provider.of<User>(context).uid == utente.uid
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileSettingsScreen(user: utente)),
                            );
                          },
                          child: Icon(
                            Icons.settings,
                            size: 30.0,
                          ),
                        )
                      : utente.type == 2
                          ? Text("")
                          : !isMyFriend()
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
                                    _removeFriend();
                                  },
                                  child: Icon(
                                    Icons.remove_circle,
                                    size: 30.0,
                                  ),
                                ),
                  SizedBox(width: 10)
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: utente.profileImage != ""
                      ? Image.network(
                          utente.profileImage,
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
                  tabs: toUseTabs,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: toUsePages),
      ),
    );
  }
}
