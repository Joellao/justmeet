import 'package:flutter/material.dart';
import 'package:justmeet/components/auth_widget.dart';
import 'package:justmeet/components/auth_widget_builder.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:justmeet/screens/authentication/login_screen.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:justmeet/screens/authentication/signup_screen.dart';
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
      ],
      child: AuthWidgetBuilder(
        builder: (context, userSnapshot) {
          return MaterialApp(
            title: 'JustMeet',
            debugShowCheckedModeBanner: false,
            home: AuthWidget(
              userSnapshot: userSnapshot,
            ),
            routes: {
              'LoginScreen': (context) => LoginScreen(),
              'SignupScreen': (context) => SignupScreen(),
              'HomePageScreen': (context) => HomePageScreen(),
              'ProfileScreen': (context) => ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
