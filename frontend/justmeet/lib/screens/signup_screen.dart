import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/screens/signup_screen_institution.dart';
import 'package:justmeet/screens/signup_screen_user.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colori.bluScuro,
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: Icon(
                Icons.person,
                color: Colori.grigio,
              )),
              Tab(
                  icon: Icon(
                Icons.location_city,
                color: Colori.grigio,
              )),
            ],
          ),
          title: Text('Scegli il tipo utente'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            SignupScreenUser(),
            SignupScreenInstitution(),
          ],
        ),
      ),
    );
  }
}
