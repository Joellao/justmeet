import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/creates/SignupUser.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:provider/provider.dart';

class SignupScreenUser extends StatefulWidget {
  @override
  _SignupScreenUserState createState() => _SignupScreenUserState();
}

class _SignupScreenUserState extends State<SignupScreenUser> {
  final _formKey = GlobalKey<FormState>();
  String _firstName, _lastName, _email, _password, _userName, _birthDate;
  Future<bool> _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SignupUser form = SignupUser(
          birthDate: _birthDate,
          firstName: _firstName,
          lastName: _lastName,
          email: _email,
          password: _password,
          userName: _userName);
      bool user = await Provider.of<AuthController>(context, listen: false)
          .signUpUser(form);
      return user;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();
    return Container(
      color: Colori.bluScuro,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Persona fisica',
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
                        onSaved: (name) => this._firstName = name,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      CustomField(
                        icon: Icons.person,
                        label: 'Cognome',
                        hint: 'Inserisci il tuo cognome',
                        validator: (lastName) => lastName.length <= 0
                            ? 'Il cognome non può essere vuoto'
                            : null,
                        onSaved: (lastName) => this._lastName = lastName,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 15,
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
                      CustomField(
                        icon: Icons.date_range,
                        label: 'Data di nascita',
                        hint: 'Inserisci la tua data di nascita',
                        validator: (birthDate) => birthDate.length < 6
                            ? 'Seleziona la data di nascita'
                            : null,
                        onSaved: (birthDate) {
                          this._birthDate = birthDate;
                        },
                        obscureText: false,
                        initialValue: this._birthDate,
                        onTap: () async {
                          DateTime now = DateTime.now();
                          DateTime initial = DateTime(1990, 1, 1);
                          DateTime last =
                              DateTime(now.year - 10, now.month, now.day);
                          Future<DateTime> future = showDatePicker(
                            context: context,
                            initialDate: initial,
                            firstDate: initial,
                            lastDate: last,
                          );
                          await future.then((date) {
                            String formatted =
                                DateFormat('dd/MM/yyyy').format(date);
                            controller.text = formatted;
                            this._birthDate = formatted;
                          });
                        },
                        controller: controller,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FlatButton(
                        color: Colori.viola,
                        padding: EdgeInsets.symmetric(
                          horizontal: 70.0,
                        ),
                        onPressed: () async {
                          bool result = await _submit();
                          if (result) {
                            Navigator.pop(context);
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "C'è stato un errore, riprova più tardi!"),
                              ),
                            );
                          }
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
