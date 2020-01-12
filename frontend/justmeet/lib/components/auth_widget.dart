import 'package:flutter/material.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:justmeet/screens/homepage_screen.dart';
import 'package:justmeet/screens/login_screen.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthController>(context, listen: false);
    return StreamBuilder(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user != null ? HomePageScreen() : LoginScreen();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
