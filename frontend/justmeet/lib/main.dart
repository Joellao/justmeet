import 'package:flutter/material.dart';
import 'package:justmeet/components/auth_widget.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:justmeet/controller/UserController.dart';
import 'package:justmeet/screens/login_screen.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:justmeet/screens/signup_screen.dart';
import 'package:justmeet/screens/homepage_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(JustMeet());

class JustMeet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthController>(
          create: (_) => AuthController(),
        ),
        FutureProvider<String>.value(
          value: AuthController().getToken(),
        ),
        FutureProvider<User>.value(
          value: AuthController().getUser(),
        ),
        Provider<UserController>(
          create: (_) => UserController(),
        )
      ],
      child: MaterialApp(
        title: 'JustMeet',
        debugShowCheckedModeBanner: false,
        home: AuthWidget(),
        routes: {
          'LoginScreen': (context) => LoginScreen(),
          'SignupScreen': (context) => SignupScreen(),
          'HomePageScreen': (context) => HomePageScreen(),
          'ProfileScreen': (context) => ProfileScreen(),
        },
      ),
    );
  }
}
