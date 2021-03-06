import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/creates/EventCreate.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/controller/EventController.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  @required
  final Event event;
  Function func;

  EditEventScreen({Key key, this.event, this.func}) : super(key: key);
  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _eventName, _location, _description, _date, _category = 'Cinema';
  bool _isFree = true;
  int _maxPersons;
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();

  Future<LinkedHashMap<String, dynamic>> _editEventFromProvider() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String token = Provider.of<String>(context, listen: false);
      EventCreate create = new EventCreate(
          name: this._eventName,
          location: this._location,
          description: this._description,
          isFree: this._isFree,
          category: this._category.toUpperCase(),
          maxPersons: this._maxPersons,
          date: this._date);
      LinkedHashMap<String, dynamic> edit =
          await Provider.of<EventController>(context, listen: false)
              .editEvent(token, this.widget.event.id, create);
      this.widget.func(true, edit);
      return edit;
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller1.text = this.widget.event.name;
    controller2.text = this.widget.event.location;
    controller3.text = this.widget.event.description;
    controller4.text = this.widget.event.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colori.bluScuro,
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
                    initialValue: this.widget.event.name,
                    icon: Icons.edit,
                    label: 'Nome evento',
                    hint: "Inserisci il nome dell'evento",
                    validator: (name) => name.length <= 0
                        ? 'Il nome non può essere vuoto'
                        : null,
                    onSaved: (name) => this._eventName = name,
                    obscureText: false,
                    controller: controller1,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  CustomField(
                    initialValue: this.widget.event.location,
                    icon: Icons.location_on,
                    label: 'Indirizzo',
                    hint: "Inserisci l'indirizzo dell'evento",
                    validator: (name) => name.length <= 0
                        ? 'Il nome non può essere vuoto'
                        : null,
                    onSaved: (name) => this._location = name,
                    obscureText: false,
                    controller: controller2,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  CustomField(
                    initialValue: this.widget.event.description,
                    icon: Icons.dehaze,
                    label: 'Descrizione',
                    hint: "Inserisci la descrizione dell'evento",
                    validator: (name) => name.length <= 0
                        ? 'Il nome non può essere vuoto'
                        : null,
                    onSaved: (name) => this._description = name,
                    obscureText: false,
                    controller: controller3,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  CustomField(
                    initialValue: this.widget.event.date,
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
                    onTap: () async {
                      DateTime now = DateTime.now();
                      DateTime initial =
                          DateTime(now.year, now.month, now.day + 1);
                      DateTime last =
                          DateTime(now.year + 2, now.month, now.day);
                      Future<DateTime> future = showDatePicker(
                        context: context,
                        initialDate: initial,
                        firstDate: initial,
                        lastDate: last,
                      );
                      await future.then((date) {
                        String formatted =
                            DateFormat('dd/MM/yyyy').format(date);
                        controller4.text = formatted;
                        this._date = formatted;
                      });
                    },
                    controller: controller4,
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
                          prefixIcon:
                              Icon(Icons.category, color: Colori.grigio),
                          focusColor: Colori.grigio,
                        ),
                        hint: new Text(
                          _category,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colori.grigio),
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
                          'Feste',
                          'Scuola'
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
                        int.parse(name) <= this.widget.event.partecipants.length
                            ? 'Deve essere maggiore del numero dei partecipanti'
                            : null,
                    onSaved: (name) => this._maxPersons = int.parse(name),
                    obscureText: false,
                  ),
                  Builder(
                    builder: (ctx) => FlatButton(
                      color: Colori.viola,
                      child: Text('Modifica Evento'),
                      onPressed: () async {
                        LinkedHashMap<String, dynamic> edit =
                            await _editEventFromProvider();
                        if (edit != null) {
                          Scaffold.of(ctx).showSnackBar(SnackBar(
                            content: Text("Evento Modificato"),
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
