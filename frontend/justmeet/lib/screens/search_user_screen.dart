import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/controller/UserController.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class SearchUserScreen extends StatefulWidget {
  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  String _userName;
  final _formKey = GlobalKey<FormState>();
  List<User> _users = [];

  Future<dynamic> _searchUser() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String token = Provider.of<String>(context, listen: false);
      List search = await Provider.of<UserController>(context, listen: false)
          .searchUser(token, this._userName);
      setState(() {
        this._users = [];
      });
      search.forEach((user) {
        setState(() {
          _users.add(User.fromJson(user));
        });
      });
    }
    return null;
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
                  hint: "Inserisci il nome utente",
                  validator: (name) =>
                      name.length <= 0 ? 'Il nome non può essere vuoto' : null,
                  onSaved: (name) => this._userName =
                      name, //salva la variabile dentro eventName
                  obscureText: false,
                ),
                FlatButton(
                  color: Colori.viola,
                  child: Text('Cerca Utente'),
                  onPressed: () async {
                    await _searchUser();
                  },
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
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: user)),
            ),
            child: Row(
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
          ),
        ],
      ),
    );
  }
}
