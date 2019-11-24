import 'package:flutter/material.dart';
import 'package:justmeet/screens/login_screen.dart';
import 'package:justmeet/screens/signup_screen.dart';
import 'package:justmeet/screens/homepage_screen.dart';

void main() => runApp(JustMeet());

class JustMeet extends StatelessWidget {
  final bool isLogged = false;

  Widget getScreen() {
    if (isLogged) {
      return HomePageScreen();
    }
    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustMeet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Container(
        child: SafeArea(
          child: getScreen(),
        ),
      ),
      routes: {
        'LoginScreen': (context) => LoginScreen(),
        'SignupScreen': (context) => SignupScreen(),
        'HomePageScreen': (context) => HomePageScreen(),
      },
    );
  }
}
