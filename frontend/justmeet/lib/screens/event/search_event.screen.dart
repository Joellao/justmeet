import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/event_widget.dart';
import 'package:justmeet/controller/EventController.dart';
import 'package:provider/provider.dart';

class SearchEventScreen extends StatefulWidget {
  @override
  _SearchEventScreenState createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
  String _eventName;
  final _formKey = GlobalKey<FormState>();
  List<Event> _events = [];

  Future<LinkedHashMap<String, dynamic>> _searchFromProvider() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String token = Provider.of<String>(context, listen: false);
      List search = await Provider.of<EventController>(context, listen: false)
          .findEvent(token, this._eventName);
      if (search != null) {
        List events2 = search;
        _events = [];
        events2.forEach((event) {
          setState(() {
            _events.add(Event.fromJson(event));
          });
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colori.bluScuro,
      child: SingleChildScrollView(
        primary: true,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 20.0,
                ),
                child: CustomField(
                  icon: Icons.edit,
                  label: 'Cerca evento',
                  hint: "Inserisci il nome dell'evento",
                  validator: (name) =>
                      name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                  onSaved: (name) => this._eventName =
                      name, //salva la variabile dentro eventName
                  obscureText: false,
                ),
              ),
              FlatButton(
                color: Colori.viola,
                child: Text('Cerca Evento'),
                onPressed: () {
                  _searchFromProvider();
                },
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _events.length,
                itemBuilder: (BuildContext context, int index) {
                  Event event = _events.elementAt(index);
                  return EventWidget(
                    event: event,
                    profileWidget: getProfileWidget(event.user),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getProfileWidget(User user) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: user.profileImage != ""
                    ? NetworkImage(user.profileImage)
                    : null,
                child: user.profileImage == ""
                    ? Icon(Icons.person, size: 25)
                    : null,
              ),
              SizedBox(
                width: 7.0,
              ),
              Text(
                user.firstName,
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                overflow: TextOverflow.fade,
              ),
              Text(" "),
              Text(
                user.lastName,
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
