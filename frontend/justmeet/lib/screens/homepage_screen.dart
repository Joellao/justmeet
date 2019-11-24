import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff99B5CB),
            Color(0xff7B95AE),
            Color(0xff57718A),
          ],
          stops: [
            0.1,
            0.6,
            1,
          ],
        ),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Just Meet",
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 32.0,
                letterSpacing: 3.0,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.white38,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding:
                  EdgeInsets.symmetric(horizontal: 45.0, vertical: 0.0),
              tabs: [
                Tab(
                  child: Text(
                    'Feed',
                    style: TextStyle(
                      fontSize: 24.0,
                      letterSpacing: 5,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Cerca',
                    style: TextStyle(
                      fontSize: 24.0,
                      letterSpacing: 5,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Profilo',
                    style: TextStyle(
                      fontSize: 24.0,
                      letterSpacing: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FeedScreen(),
              SearchScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
