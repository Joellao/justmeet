import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool isLoading = false;
  String errore;

  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      try {
        await Provider.of<AuthController>(context, listen: false)
            .signIn(_email, _password);
      } on Exception catch (error) {
        if (error.toString() == "Exception: authProblems.UserNotFound") {
          setState(() {
            errore = "Utente non trovato";
          });
        }
        if (error.toString() == "Exception: authProblems.NetworkError") {
          setState(() {
            errore = "Errore di connessione";
          });
        }
        if (error.toString() == "Exception: authProblems.PasswordNotValid") {
          setState(() {
            errore = "I dati inseriti non sono validi";
          });
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
  );

  Future<void> googleSignIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      GoogleSignInAccount login = await _googleSignIn.signIn();
      AuthController controller = new AuthController();
      await controller.googleSignIn(login);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colori.bluScuro,
        child: Center(
          child: !isLoading
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'JustMeet',
                        style: TextStyle(
                          color: Colori.grigio,
                          fontSize: 60.0,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Ciao, effettua il login',
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
                              errore != null
                                  ? Text(
                                      errore,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 24),
                                    )
                                  : SizedBox(),
                              CustomField(
                                icon: Icons.mail,
                                label: 'Email',
                                hint: "Inserisci l'email",
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
                                height: 15.0,
                              ),
                              CustomField(
                                icon: Icons.lock,
                                label: 'Password',
                                hint: 'Inserisci la tua password',
                                validator: (password) => password.length < 8
                                    ? 'Non può essere minore di 8'
                                    : null,
                                onSaved: (password) =>
                                    this._password = password,
                                obscureText: true,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              FlatButton(
                                color: Colori.viola,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 70.0,
                                ),
                                onPressed: _submit,
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colori.grigio,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, 'SignupScreen'),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Crea un ',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'account.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: FlatButton.icon(
                                  onPressed: googleSignIn,
                                  textColor: Colori.grigio,
                                  splashColor: Colors.amber,
                                  icon: Icon(
                                    Icons.cloud,
                                    color: Colori.bluScuro,
                                  ),
                                  label: Text("Google SignIn"),
                                  color: Colori.viola,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Login in corso",
                      style: TextStyle(color: Colori.grigio, fontSize: 20),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
        ),
      ),
    );
  }
}
