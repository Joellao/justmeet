import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/screens/profile_announcement_screen.dart';
import 'package:justmeet/screens/profile_event_screen.dart';
import 'package:justmeet/screens/profile_settings_screen.dart';
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

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // This is the number of tabs.
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
                      : null,
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
                    Tab(child: Text("Annunci"))
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
            ]),
      ),
    );
  }
}
