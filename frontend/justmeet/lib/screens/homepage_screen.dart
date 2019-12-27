import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/screens/feed_screen.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:justmeet/screens/search_screen.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key key}) : super(key: key);

  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController;
  int index = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text("JustMeet"),
        centerTitle: true,
        backgroundColor: Color(0xFF5257F2),
      ),
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            this.index = index;
          });
        },
        controller: _pageController,
        children: [
          FeedScreen(),
          SearchScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 45,
        animationDuration: Duration(milliseconds: 250),
        index: this.index,
        backgroundColor: Color(0xFF5257F2),
        items: <Widget>[
          Icon(Icons.art_track, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            this.index = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
