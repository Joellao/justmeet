import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/widgets/event_widget.dart';
import 'package:provider/provider.dart';

class SearchEventScreen extends StatefulWidget {
  @override
  _SearchEventScreenState createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
  String _eventName;
  final _formKey = GlobalKey<FormState>();
  List<Event> _events = [];

  _submit() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context, listen: false);
        Response response = await dio.get(
          "https://justmeetgjj.herokuapp.com/event/$_eventName/find",
          options: Options(
            headers: {
              "Authorization": token,
            },
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          print(response.data);

          List events2 = response.data;
          events2.forEach((event) {
            setState(() {
              _events.add(Event.fromJson(event));
            });
          });
        }
      } on DioError catch (e) {
        print(e.response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colori.bluScuro,
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
                  label: 'Cerca evento',
                  hint: "Inserisci il nome dell'evento",
                  validator: (name) =>
                      name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                  onSaved: (name) => this._eventName =
                      name, //salva la variabile dentro eventName
                  obscureText: false,
                ),
                FlatButton(
                  color: Colori.viola,
                  child: Text('Cerca Evento'),
                  onPressed: _submit,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _events.length,
                  itemBuilder: (BuildContext context, int index) {
                    Event event = _events.elementAt(index);
                    return EventWidget(
                      event: event,
                      profileWidget: getProfileWidget(event),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getProfileWidget(Event event) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: event.user.profileImage != ""
                    ? NetworkImage(event.user.profileImage)
                    : null,
                child: event.user.profileImage == ""
                    ? Icon(Icons.person, size: 25)
                    : null,
              ),
              SizedBox(
                width: 7.0,
              ),
              Text(
                event.user.firstName,
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(" "),
              Text(
                event.user.lastName,
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
          InkWell(
            onTap: () => print("More premuto"),
            child: Icon(
              Icons.more_vert,
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
