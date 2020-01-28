import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/creates/SignupInstitution.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:provider/provider.dart';

class SignupScreenInstitution extends StatefulWidget {
  @override
  _SignupScreenInstitutionState createState() =>
      _SignupScreenInstitutionState();
}

class _SignupScreenInstitutionState extends State<SignupScreenInstitution> {
  final _formKey = GlobalKey<FormState>();
  String _name, _password, _email, _userName;

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SignupInstitution form = SignupInstitution(
          email: _email, password: _password, name: _name, userName: _userName);
      await Provider.of<AuthController>(context, listen: false)
          .signUpInstitution(form);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colori.bluScuro,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Istituzione',
                style: TextStyle(
                  color: Colori.grigio,
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
                        icon: Icons.person,
                        label: 'Nome',
                        hint: 'Inserisci il tuo nome',
                        validator: (name) => name.length <= 0
                            ? 'Il nome non può essere vuoto'
                            : null,
                        onSaved: (name) => this._name = name,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      CustomField(
                        icon: Icons.mail,
                        label: 'Email',
                        hint: 'Inserisci la tua mail',
                        validator: (email) {
                          if (email.isEmpty) {
                            return "L'email non può essere vuoto";
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email);
                          if (!emailValid) {
                            return "Non è un email valido";
                          }
                          return null;
                        },
                        onSaved: (email) => this._email = email,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomField(
                        icon: Icons.lock,
                        label: 'Password',
                        hint: 'Inserisci la tua password',
                        validator: (password) => password.length < 8
                            ? 'Non può essere minore di 8'
                            : null,
                        onSaved: (password) => this._password = password,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomField(
                        icon: Icons.person_outline,
                        label: 'Username',
                        hint: 'Inserisci il tuo username',
                        validator: (userName) => userName.length <= 0
                            ? 'Non può essere vuoto'
                            : null,
                        onSaved: (userName) => this._userName = userName,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FlatButton(
                        color: Colori.viola,
                        padding: EdgeInsets.symmetric(
                          horizontal: 70.0,
                        ),
                        onPressed: () {
                          _submit();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Registrati",
                          style: TextStyle(
                            color: Colori.grigio,
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
      ),
    );
  }
}
