import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/comment.dart';
import 'package:justmeet/components/models/creates/CommentCreate.dart';
import 'package:justmeet/controller/CommentController.dart';
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

  Future<LinkedHashMap<String, dynamic>> _editCommentProvider() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String token = Provider.of<String>(context, listen: false);
      CommentCreate create = new CommentCreate(body: _body);
      LinkedHashMap<String, dynamic> comment =
          await Provider.of<CommentController>(context, listen: false)
              .editComment(token, this.widget.comment.id, create);
      this.widget.modifyFunc(true, comment, this.widget.index);
      return comment;
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
                        LinkedHashMap<String, dynamic> edit =
                            await _editCommentProvider();
                        if (edit != null) {
                          Comment comment = Comment.fromJson(edit);
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
