import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/comment.dart';
import 'package:provider/provider.dart';

class EditCommentScreen extends StatefulWidget {
  Comment comment;
  Function modifyFunc;
  int index;

  EditCommentScreen({Key key, this.comment, this.modifyFunc, this.index})
      : super(key: key);
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
          Comment comment = Comment.fromJson(response.data);
          this.widget.modifyFunc(true, response.data, this.widget.index);
          return comment;
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
      appBar: AppBar(
        backgroundColor: Colori.bluScuro,
        elevation: 1,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                      onPressed: () async {
                        Comment comment = await _submit();
                        if (comment != null) {
                          controller1.text = comment.body;
                          this.widget.comment = comment;
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
