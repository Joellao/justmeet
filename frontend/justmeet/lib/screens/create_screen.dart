import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/screens/new_announcement_screen.dart';
import 'package:justmeet/screens/new_event_screen.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
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
                  new Tab(icon: new Icon(Icons.airline_seat_recline_extra)),
                  new Tab(icon: new Icon(Icons.accessible_forward)),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NewEventScreen(),
            NewAnnouncementScreen(),
          ],
        ),
      ),
    );
  }
}
