import 'package:flutter/material.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class EventWidget extends StatelessWidget {
  final Event event;
  final Widget widget;
  EventWidget({this.event, this.widget}) : super();
  static Future<void> openMap(String location) async {
    String result = location.replaceAll(RegExp(' '), '+');
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${result}';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Card(
        elevation: 4,
        color: Color(0XFFe1e2ef),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: <Widget>[
            this.widget != null ? this.widget : SizedBox(),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.network(
                      "https://apprecs.org/ios/images/app-icons/256/ca/644106186.jpg",
                      height: 90,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        event.name,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        event.location,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      event.description != ""
                          ? Text(
                              event.description,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(),
                      Text(
                        event.date,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () => openMap(event.location),
                            child: Icon(
                              Icons.directions,
                              size: 40,
                              color: Color(0xFF02020a),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Aggiungi ai preferiti"),
                            )),
                            child: Icon(
                              Icons.star,
                              size: 45,
                              color:
                                  /*event.partecipants.contains(
                                      Provider.of<AuthController>(context)
                                          .getUser())*/
                                  "ciao" != "ciao"
                                      ? Color(0xFF695E6C)
                                      : Color(0xFFbfacc8),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 70,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF695E6C), width: 1.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Totali",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Color(0xFF695E6C),
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            event.maxNumber.toString(),
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Container(
                    width: 70,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF695E6C), width: 1.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Rimasti",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Color(0xFF695E6C),
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            (event.maxNumber - event.partecipants.length)
                                .toString(),
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: RaisedButton(
                      color: Color(0xFF5257f2),
                      elevation: 4,
                      disabledColor: Colors.red,
                      child: Text(
                        "Prenotati",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed:
                          ((event.maxNumber - event.partecipants.length) > 0)
                              ? () =>
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Prenotazione effettuata"),
                                  ))
                              : null,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
