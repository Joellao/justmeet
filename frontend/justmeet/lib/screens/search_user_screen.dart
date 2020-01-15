import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:provider/provider.dart';

class SearchUserScreen extends StatefulWidget {
  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  String _userName;
  final _formKey = GlobalKey<FormState>();
  List<User> _users = [];

  _submit() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context);
        Response response = await dio.get(
          "https://justmeetgjj.herokuapp.com/user/$_userName/find",
          options: Options(
            headers: {
              "Authorization": token,
            },
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          print(response.data);

          List users2 = response.data;
          users2.forEach((user) {
            setState(() {
              _users.add(User.fromJson(user));
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
                  label: 'Cerca utente',
                  hint: "Inserisci il nome dell'utente",
                  validator: (name) =>
                      name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                  onSaved: (name) => this._userName =
                      name, //salva la variabile dentro eventName
                  obscureText: false,
                ),
                FlatButton(
                  color: Colori.viola,
                  child: Text('Cerca Utente'),
                  onPressed: _submit,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _users.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user = _users.elementAt(index);
                    return getProfileWidget(user);
                  },
                )
              ],
            ),
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
                    ? Icon(Icons.person, size: 25, color: Colori.grigio)
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
                    color: Colori.grigio,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(" "),
              Text(
                user.lastName,
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Colori.grigio,
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
              color: Colori.grigio,
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
