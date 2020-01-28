import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/screens/map_screen.dart';
import 'package:justmeet/screens/search_event.screen.dart';
import 'package:justmeet/screens/search_user_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colori.bluScuro,
          flexibleSpace: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new TabBar(
                isScrollable: false,
                dragStartBehavior: DragStartBehavior.down,
                tabs: [
                  new Tab(icon: new Icon(Icons.beach_access)),
                  new Tab(icon: new Icon(Icons.person)),
                  new Tab(icon: new Icon(Icons.map)),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            SearchEventScreen(),
            SearchUserScreen(),
            MapScreen(),
          ],
        ),
      ),
    );
  }
}
