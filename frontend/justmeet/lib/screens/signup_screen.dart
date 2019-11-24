import 'package:flutter/material.dart';
import 'package:justmeet/components/custom_field.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username, _password, _email;
  bool isLoading = false;

  _submit() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      print(_password);
      print(_email);
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Crea il tuo account',
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
                        hint: 'Enter your email',
                        validator: (email) => email.length < 6
                            ? 'Non può essere minore di 6'
                            : null,
                        onSaved: (email) => this._email = email),
                    SizedBox(
                      height: 15.0,
                    ),
                    CustomField(
                        icon: Icons.lock,
                        label: 'Password',
                        hint: 'Enter your password',
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
                      onPressed: () => print("Login cliccato"),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
