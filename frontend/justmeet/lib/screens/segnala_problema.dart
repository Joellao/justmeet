import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:provider/provider.dart';

class ReportProblemScreen extends StatefulWidget {
  // const ReportProblemScreen({Key key, this.commentId}) : super(key: key);
  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _body;

  Future<bool> _submit() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context, listen: false);
        Response response = await dio.post(
          "https://justmeetgjj.herokuapp.com/report",
          queryParameters: {'body': this._body},
          options: Options(
            headers: {
              "Authorization": token,
            },
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          print(response.data);
          print("Segnalato con successo");
          return true;
        }
      } on DioError catch (e) {
        print(e.response);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();
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
                          bool submit = await _submit();
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
