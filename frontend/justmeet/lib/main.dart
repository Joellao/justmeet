import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:justmeet/screens/login_screen.dart';
import 'package:justmeet/screens/signup_screen.dart';
import 'package:justmeet/screens/homepage_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(JustMeet());

class JustMeet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustMeet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: HomePageScreen(),
      routes: {
        'LoginScreen': (context) => LoginScreen(),
        'SignupScreen': (context) => SignupScreen(),
        'HomePageScreen': (context) => HomePageScreen(),
      },
    );
  }
}
