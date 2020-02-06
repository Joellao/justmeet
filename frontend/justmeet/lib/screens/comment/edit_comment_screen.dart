import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/comment.dart';
import 'package:provider/provider.dart';

class EditCommentScreen extends StatefulWidget {
  final Comment comment;

  const EditCommentScreen({Key key, this.comment}) : super(key: key);
  @override
  _EditCommentScreenState createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _body;

  Future<Comment> _submit() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context, listen: false);
        print(this._body);
        Response response = await dio.put(
          "https://justmeetgjj.herokuapp.com/comment/${this.widget.comment.id}",
          data: {
            "body": _body,
          },
          options: Options(
            headers: {
              "Authorization": token,
            },
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          print(response.data);
          print("Modificato con successo");
          return Comment.fromJson(response.data);
        }
      } on DioError catch (e) {
        print(e.response);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller1 = new TextEditingController();

    controller1.text = this.widget.comment.body;

    return Scaffold(
      body: Container(
        color: Color(0xFF05204a),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Modifica Commento",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colori.grigio),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomField(
                    initialValue: this.widget.comment.body,
                    icon: Icons.dehaze,
                    label: 'Descrizione',
                    hint: "Inserisci la descrizione dell'evento",
                    validator: (name) => name.length <= 0
                        ? 'Il nome non può essere vuoto'
                        : null,
                    onSaved: (name) => this._body = name,
                    obscureText: false,
                    controller: controller1,
                  ),
                  Builder(
                    builder: (ctx) => FlatButton(
                      color: Colori.viola,
                      child: Text('Modifica commento'),
                      onPressed: () {
                        if (_submit() != null) {
                          Scaffold.of(ctx).showSnackBar(SnackBar(
                            content: Text("Commento Modificato"),
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
    );
  }
}
