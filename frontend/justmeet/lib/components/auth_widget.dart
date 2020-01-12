import 'package:flutter/material.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:justmeet/screens/homepage_screen.dart';
import 'package:justmeet/screens/login_screen.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<DummyUser> userSnapshot;
  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? HomePageScreen() : LoginScreen();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
