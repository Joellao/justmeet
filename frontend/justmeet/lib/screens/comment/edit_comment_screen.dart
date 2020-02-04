import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
        Response response = await dio.put(
          "https://justmeetgjj.herokuapp.com/comment/${this.widget.comment.id}",
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
    TextEditingController controller = new TextEditingController();
    controller.text = this.widget.comment.body;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colori.bluScuro,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFF05204a),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 70.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Modifica commento",
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
                    label: 'Commento',
                    hint: "Inserisci il commento",
                    validator: (body) => body.length <= 0
                        ? 'Il commento non può essere vuoto'
                        : null,
                    onSaved: (body) => this._body = body,
                    obscureText: false,
                    controller: controller,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  FlatButton(
                    color: Colori.viola,
                    child: Text(
                      'Modifica',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colori.grigio,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      Comment comment = await _submit();
                      if (comment != null) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Commento modificato"),
                        ));
                      }
                    },
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
