import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/screens/create_screen.dart';
import 'package:justmeet/screens/feed_screen.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:justmeet/screens/search_screen.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key key}) : super(key: key);

  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController;
  User user;
  // pagina con stato index =0 mi permette di cambiare lo stato interno della classe e quindi se cambio pagina ridipingo tutto.
  // se cambio stato vado ad un altra pagina e mi ricarica una nuova pagine con nuove cose e fa tutto lui
  int index = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    this.user = getUser();
  }

  User getUser() {
    User user = Provider.of<User>(context);
    return user;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: Text("JustMeet"),
              centerTitle: true,
              backgroundColor: Colori.bluScuro,
              actions: <Widget>[
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: this.user)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: user.profileImage != ""
                          ? NetworkImage(user.profileImage)
                          : null,
                      child: user.profileImage == ""
                          ? Icon(Icons.person, size: 25)
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
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
                CreateScreen(),
                SearchScreen(),
              ],
            ),
            bottomNavigationBar: CurvedNavigationBar(
              height: 45,
              animationDuration: Duration(milliseconds: 250),
              index: this.index,
              backgroundColor: Colori.bluScuro,
              color: Colori.grigio,
              items: <Widget>[
                Icon(Icons.art_track, size: 30),
                Icon(Icons.add_box, size: 30),
                Icon(Icons.search, size: 30),
              ],
              onTap: (index) {
                setState(() {
                  this.index = index;
                });
                _pageController.jumpToPage(index);
              },
            ),
          )
        : Container(
            color: Colori.bluScuro,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
