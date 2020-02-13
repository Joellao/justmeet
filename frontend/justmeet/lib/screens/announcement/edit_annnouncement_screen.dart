import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/announcement.dart';
import 'package:provider/provider.dart';

class EditAnnouncementScreen extends StatefulWidget {
  @required
  Announcement announce;
  Function func;

  EditAnnouncementScreen({Key key, this.announce}) : super(key: key);
  @override
  _EditAnnouncementScreenState createState() => _EditAnnouncementScreenState();
}

class _EditAnnouncementScreenState extends State<EditAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  String _announceName, _description, _category = 'Cinema';

  _editEvent() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context, listen: false);
        print(_description);
        Response response = await dio.put(
          "https://justmeetgjj.herokuapp.com/event/${this.widget.announce.id}",
          data: {
            "name": _announceName,
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
          print(response.data);
          print("Annuncio modificato");
          this.widget.func(true, response.data);
        }
      } on DioError catch (e) {
        print(e.response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller1 = new TextEditingController();
    TextEditingController controller3 = new TextEditingController();

    controller1.text = this.widget.announce.name;
    controller3.text = this.widget.announce.description;

    return Scaffold(
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
                "Modifica Evento",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colori.grigio),
                ),
              ),
              SizedBox(height: 10),
              CustomField(
                initialValue: this.widget.announce.name,
                icon: Icons.edit,
                label: 'Nome annuncio',
                hint: "Inserisci il nome dell'annuncio",
                validator: (name) =>
                    name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                onSaved: (name) => this._announceName = name,
                obscureText: false,
                controller: controller1,
              ),
              SizedBox(
                height: 15.0,
              ),
              CustomField(
                initialValue: this.widget.announce.description,
                icon: Icons.dehaze,
                label: 'Descrizione',
                hint: "Inserisci la descrizione dell'annuncio",
                validator: (name) =>
                    name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                onSaved: (name) => this._description = name,
                obscureText: false,
                controller: controller3,
              ),
              SizedBox(
                height: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Categoria',
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
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    isExpanded: true,
                    iconEnabledColor: Colori.grigio,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colori.grigio,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colori.grigio,
                        ),
                      ),
                      prefixIcon: Icon(Icons.category, color: Colori.grigio),
                      focusColor: Colori.grigio,
                    ),
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
                child: Text('Modifica Annuncio'),
                onPressed: () {
                  if (_editEvent() != null) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Annuncio Modificato"),
                    ));
                  }
                },
              )
            ],
          ),
        ),
      )),
    ));
  }
}
