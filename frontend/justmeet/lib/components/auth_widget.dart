import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:justmeet/screens/homepage_screen.dart';
import 'package:justmeet/screens/login_screen.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<DummyUser> userSnapshot;
  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      //print(Provider.of<User>(context) == null ? "ciao" : "no");
      return userSnapshot.hasData
          ? Provider.of<User>(context) != null
              ? (Provider.of<User>(context).type == 1
                  ? HomePageScreen()
                  : ProfileScreen(user: Provider.of<User>(context)))
              : Scaffold(
                  body: Container(
                    color: Colori.bluScuro,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
          : LoginScreen();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
