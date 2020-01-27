import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/custom_field.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/review.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/review_widget.dart';
import 'package:justmeet/components/widgets/star_rating.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewScreen extends StatefulWidget {
  final Event event;

  const ReviewScreen({Key key, this.event}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  static Future<void> openMap(String location) async {
    String result = location.replaceAll(RegExp(' '), '+');
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$result';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  final _formKey = GlobalKey<FormState>();
  String _body;
  int _stars;

  _submit() async {
    print("Entrato");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_body);
      try {
        Dio dio = new Dio();
        String token = Provider.of<String>(context);
        Response response = await dio.post(
          "https://justmeetgjj.herokuapp.com/event/${this.widget.event.id}/review",
          data: {
            "body": _body,
            "stars": _stars,
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
          print("Recensione aggiunta");
        }
      } on DioError catch (e) {
        print(e.response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.event.name),
        backgroundColor: Colori.bluScuro,
        actions: <Widget>[
          user.uid == this.widget.event.user.uid
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => null));
                  },
                  child: Icon(
                    Icons.settings,
                    size: 30.0,
                  ),
                )
              : null,
          SizedBox(width: 10)
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colori.bluScuro,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FormField<int>(
                        initialValue: 1,
                        autovalidate: true,
                        builder: (state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              StarRating(
                                onChanged: state.didChange,
                                value: state.value,
                              ),
                            ],
                          );
                        },
                        validator: (value) =>
                            value < 1 ? 'Voto troppo basso' : null,
                        onSaved: (value) => this._stars = value,
                      ),
                      CustomField(
                        icon: Icons.comment,
                        label: '',
                        hint: "Aggiungi recensione",
                        validator: (name) => name.length <= 0
                            ? 'La recensione non può essere vuota'
                            : null,
                        onSaved: (name) => this._body = name,
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _submit(),
                  child: Icon(
                    Icons.send,
                    color: Colori.grigio,
                    size: 40,
                  ),
                ),
                Column(
                  children:
                      List.generate(this.widget.event.reviews.length, (index) {
                    Review r = Review.fromJson(
                        this.widget.event.reviews.elementAt(index));
                    return ReviewWidget(
                      review: r,
                      profileWidget: getProfileWidget(this.widget.event),
                    );
                  }),
                ),
                SizedBox(height: 10),
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
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: event.user)),
            ),
            child: Row(
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
