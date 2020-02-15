import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/controller/ReportProblemController.dart';
import 'package:provider/provider.dart';

class ReportProblemScreen extends StatefulWidget {
  // const ReportProblemScreen({Key key, this.commentId}) : super(key: key);
  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _body;

  Future<bool> _createProblem() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String token = Provider.of<String>(context, listen: false);
      return await Provider.of<ReportProblemController>(context, listen: false)
          .reportProblem(token, this._body);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colori.bluScuro,
        elevation: 1,
        title: Text("Segnalazione"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFF05204a),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 30.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Segnala un problema",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colori.grigio,
                          fontSize: 35,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    CustomField(
                      icon: Icons.edit,
                      label: 'Motivo segnalazione',
                      hint: "Inserisci il motivo della segnalazione",
                      validator: (body) => body.length <= 0
                          ? 'Il motivo non può essere vuoto'
                          : null,
                      onSaved: (body) => this._body = body,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Builder(
                      builder: (context) => FlatButton(
                        color: Colori.viola,
                        child: Text(
                          'Segnala',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colori.grigio,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          bool submit = await _createProblem();
                          if (submit) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Segnalazione effettuata con successo"),
                            ));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
