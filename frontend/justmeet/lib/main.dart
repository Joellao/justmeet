import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:justmeet/screens/login_screen.dart';
import 'package:justmeet/screens/signup_screen.dart';
import 'package:justmeet/screens/homepage_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider<AuthController>(
        child: JustMeet(),
        create: (BuildContext context) {
          return AuthController();
        },
      ),
    );

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
    return MaterialApp(
      title: 'JustMeet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: FutureBuilder(
          future: Provider.of<AuthController>(context).getUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.error != null) {
                print("error");
                return Text(snapshot.error.toString());
              }
              return snapshot.hasData ? HomePageScreen() : LoginScreen();
            } else {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment(0.0, 0.0),
                ),
              );
            }
          }),
      routes: {
        'LoginScreen': (context) => LoginScreen(),
        'SignupScreen': (context) => SignupScreen(),
        'HomePageScreen': (context) => HomePageScreen(),
      },
    );
  }
}
