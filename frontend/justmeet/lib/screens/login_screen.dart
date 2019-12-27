import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username, _password;
  bool isLoading = false;

  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      try {
        FirebaseUser result = await Provider.of<AuthController>(context)
            .signIn(_username, _password);
      } on AuthException catch (error) {
        print(error);
      } on Exception catch (error) {
        print(error);
      }
      // if (result != null) {
      //   Navigator.pushReplacementNamed(context, "HomePageScreen");
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff99B5CB),
            Color(0xff7B95AE),
            Color(0xff57718A),
          ],
          stops: [
            0.1,
            0.6,
            1,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'JustMeet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60.0,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Hello, login below',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 20.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomField(
                        icon: Icons.mail,
                        label: 'Email',
                        hint: "Inserisci l'email",
                        validator: (username) => username.length < 6
                            ? 'Non può avere meno di 6 caratteri'
                            : null,
                        onSaved: (username) => this._username = username),
                    SizedBox(
                      height: 15.0,
                    ),
                    CustomField(
                        icon: Icons.lock,
                        label: 'Password',
                        hint: 'Inserisci la tua password',
                        validator: (password) => password.length < 6
                            ? 'Non può essere minore di 6'
                            : null,
                        onSaved: (password) => this._password = password),
                    SizedBox(
                      height: 15,
                    ),
                    FlatButton(
                      color: Colors.grey,
                      padding: EdgeInsets.symmetric(
                        horizontal: 70.0,
                      ),
                      onPressed: _submit,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () => print('Password dimenticata'),
                      child: RichText(
                        text: TextSpan(
                          text: 'Dimenticata la ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'password?',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'SignupScreen'),
                      child: RichText(
                        text: TextSpan(
                          text: 'Crea un ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'account.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
