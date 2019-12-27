import 'package:flutter/material.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:provider/provider.dart';

class EventFeed extends StatelessWidget {
  final Event event;
  EventFeed({this.event}) : super();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: GestureDetector(
                    onTap: () => Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Profilo cliccato"),
                    )),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(event.user.profileImage),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            event.user.firstName + " " + event.user.lastName,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Più cliccato"),
                    )),
                    child: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
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
                      height: 150,
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
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        event.location,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        "Festa di capodanno 2020 offerto da JustMeet 💋",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        event.date,
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        children: <Widget>[
                          FloatingActionButton(
                            elevation: 0,
                            mini: true,
                            onPressed: () =>
                                Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Apertura Google Maps"),
                            )),
                            child: Icon(Icons.directions),
                          ),
                          FloatingActionButton(
                            elevation: 0,
                            mini: true,
                            backgroundColor: event.partecipants.contains(
                                    Provider.of<AuthController>(context)
                                        .getUser())
                                ? Colors.grey
                                : Colors.red,
                            onPressed: () =>
                                Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Aggiungi ai preferiti"),
                            )),
                            child: Icon(Icons.star),
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
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Totali",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          event.maxNumber.toString(),
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
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
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Rimasti",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          (event.maxNumber - event.partecipants.length)
                              .toString(),
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
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
                      color: Colors.green,
                      elevation: 4,
                      disabledColor: Colors.red,
                      child: Text("Prenotati"),
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
