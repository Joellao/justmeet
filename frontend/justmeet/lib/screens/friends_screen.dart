import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/screens/request_friends.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colori.bluScuro,
          flexibleSpace: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new TabBar(
                tabs: [
                  new Tab(icon: new Icon(Icons.people)),
                  new Tab(icon: new Icon(Icons.people_outline)),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RequestFriendsScreen(),
          ],
        ),
      ),
    );
  }
}
