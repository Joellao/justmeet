import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:provider/provider.dart';

class NewEventScreen extends StatefulWidget {
  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _eventName, _location, _description, _date, _category = 'Cinema';
  bool _isFree = true;
  int _maxPersons;

  _submit() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_eventName);
      print(_location);
      print(_description);
      print(_date);
      print(_category);
      print(_isFree);
      print(_maxPersons);
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context, listen: false);
        Response response = await dio.post(
          "https://justmeetgjj.herokuapp.com/event",
          data: {
            "name": _eventName,
            "location": _location,
            "description": _description,
            "isFree": _isFree,
            "category": _category.toUpperCase(),
            "maxPersons": _maxPersons,
            'date': _date
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
          print("Evento creato con successo");
        }
      } on DioError catch (e) {
        print(e.response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();
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
                label: 'Nome evento',
                hint: "Inserisci il nome dell'evento",
                validator: (name) =>
                    name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                onSaved: (name) => this._eventName = name,
                obscureText: false,
              ),
              SizedBox(
                height: 15.0,
              ),
              CustomField(
                icon: Icons.location_on,
                label: 'Indirizzo',
                hint: "Inserisci l'indirizzo dell'evento",
                validator: (name) =>
                    name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                onSaved: (name) => this._location = name,
                obscureText: false,
              ),
              SizedBox(
                height: 15.0,
              ),
              CustomField(
                icon: Icons.dehaze,
                label: 'Descrizione',
                hint: "Inserisci la descrizione dell'evento",
                validator: (name) =>
                    name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                onSaved: (name) => this._description = name,
                obscureText: false,
              ),
              SizedBox(
                height: 15.0,
              ),
              CustomField(
                icon: Icons.date_range,
                label: 'Data evento',
                hint: "Inserisci la data dell'evento",
                validator: (birthDate) => birthDate.length < 6
                    ? 'Seleziona la data di nascita'
                    : null,
                onSaved: (birthDate) {
                  this._date = birthDate;
                },
                obscureText: false,
                initialValue: this._date,
                onTap: () async {
                  DateTime now = DateTime.now();
                  DateTime initial = DateTime(now.year, now.month, now.day + 1);
                  DateTime last = DateTime(now.year + 2, now.month, now.day);
                  Future<DateTime> future = showDatePicker(
                    context: context,
                    initialDate: initial,
                    firstDate: initial,
                    lastDate: last,
                  );
                  await future.then((date) {
                    String formatted = DateFormat('dd/MM/yyyy').format(date);
                    controller.text = formatted;
                    this._date = formatted;
                  });
                },
                controller: controller,
              ),
              SizedBox(
                height: 15.0,
              ),
              SwitchListTile(
                title: Text(
                  'Evento gratuito?',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colori.grigio),
                  ),
                ),
                value: this._isFree,
                onChanged: (bool value) {
                  setState(() {
                    this._isFree = value;
                  });
                },
                secondary: const Icon(
                  Icons.attach_money,
                  color: Colori.grigio,
                ),
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
              CustomField(
                icon: Icons.supervisor_account,
                label: 'Massimo numero partecipanti',
                hint:
                    "Inserisci il massimo numero dei partecipanti dell'evento",
                validator: (name) =>
                    name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                onSaved: (name) => this._maxPersons = int.parse(name),
                obscureText: false,
              ),
              FlatButton(
                color: Colori.viola,
                child: Text('Crea Evento'),
                onPressed: () {
                  if (_submit() != null) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Evento creato"),
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
