import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/screens/profile_screen.dart';

class MyFriendsScreen extends StatelessWidget {
  final List<dynamic> friends;

  const MyFriendsScreen({Key key, @required this.friends}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colori.bluScuro,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: friends.length,
                  itemBuilder: (BuildContext context, int index) {
                    User com = User.fromJson(this.friends.elementAt(index));
                    return getProfileWidget(context, com);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getProfileWidget(BuildContext context, User user) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: user)),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: user.profileImage != ""
                      ? NetworkImage(user.profileImage)
                      : null,
                  child: user.profileImage == ""
                      ? Icon(Icons.person, size: 25, color: Colori.grigio)
                      : null,
                ),
                SizedBox(
                  width: 7.0,
                ),
                Text(
                  user.firstName,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colori.grigio,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(" "),
                Text(
                  user.lastName,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colori.grigio,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
