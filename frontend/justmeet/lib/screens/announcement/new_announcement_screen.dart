import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:provider/provider.dart';

class NewAnnouncementScreen extends StatefulWidget {
  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  String _announcementName, _description, _category = 'Cinema';

  _submit() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_announcementName);

      print(_category);

      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context, listen: false);
        Response response = await dio.post(
          "https://justmeetgjj.herokuapp.com/announcement",
          data: {
            "name": _announcementName,
            "description": _description,
            "category": _category.toUpperCase(),
          },
          options: Options(
            headers: {
              "Authorization": token,
            },
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          print("Annuncio creato con successo");
          User user = Provider.of<User>(context, listen: false);
          List list = user.announcements;
          list.add(response.data);
          Provider.of<User>(context, listen: false).update(
              user.uid,
              user.firstName,
              user.lastName,
              user.birthDate,
              user.email,
              user.bio,
              user.events,
              user.profileImage,
              user.username,
              list,
              user.friends,
              user.friendRequests,
              user.partecipatedEvents);
        }
      } on DioError catch (e) {
        print(e.response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              CustomField(
                icon: Icons.edit,
                label: 'Nome annuncio',
                hint: "Inserisci il nome dell'annuncio",
                validator: (name) =>
                    name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                onSaved: (name) => this._announcementName = name,
                obscureText: false,
              ),
              SizedBox(
                height: 15.0,
              ),
              CustomField(
                icon: Icons.dehaze,
                label: 'Descrizione',
                hint: "Inserisci la descrizione dell'annuncio",
                validator: (name) =>
                    name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                onSaved: (name) => this._description = name,
                obscureText: false,
              ),
              SizedBox(
                height: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Categoria',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colori.grigio,
                        shadows: [
                          Shadow(
                            color: Colori.grigio,
                            offset: Offset(0, 0),
                          ),
                        ],
                      )),
                  DropdownButtonFormField<String>(
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    isExpanded: true,
                    hint: new Text(
                      _category,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colori.grigio),
                      ),
                    ),
                    items: <String>[
                      'Cinema',
                      'Fiere',
                      'Conferenze',
                      'Mostre',
                      'Sport',
                      'Musica',
                      'Sagre',
                      'Teatro',
                      'Feste'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colori.nero),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        this._category = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              FlatButton(
                color: Colori.viola,
                child: Text('Crea Annuncio'),
                onPressed: () {
                  if (_submit() != null) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Annuncio creato"),
                    ));
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
