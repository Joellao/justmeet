import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/widgets/EventFeed.dart';
import 'package:justmeet/components/widgets/event_widget.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Dio dio = new Dio();
  Future<List<Event>> events;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    events = getData();
  }

  Future<List<Event>> getData() async {
    //FirebaseUser user = await Provider.of<AuthController>(context).getUser();
    //IdTokenResult token = await user.getIdToken();
    // Response response = await dio.get(
    //   "https://justmeetgjj.herokuapp.com/event/",
    //   options: Options(
    //     headers: {
    //       "Authorization": token.token,
    //     },
    //   ),
    // );
    Response response = new Response(
        statusCode: 200,
        data:
            '[{"id":3,"name":"Evento 3","user":{"uid":"0yISKL488gTvdPS1vckvyAoRwOu2","firstName":"Joel","email":"joel.sina97@gmail.com","profileImage":null,"bio":null,"type":1,"canCreatePublicEvent":false,"canSeeOthersProfile":true,"lastName":"Sina","birthDate":"04/08/1997"},"location":"SSM","date":"21/12/2019","description":null,"cancelled":false,"categoria":"Cat","maxNumber":8,"comments":[{"id":6,"body":"Commento Evento 3","user":{"uid":"0yISKL488gTvdPS1vckvyAoRwOu2","firstName":"Joel","email":"joel.sina97@gmail.com","profileImage":null,"bio":null,"type":1,"canCreatePublicEvent":false,"canSeeOthersProfile":true,"lastName":"Sina","birthDate":"04/08/1997"},"date":"Oggi","state":false}],"reviews":[],"partecipants":[],"publicEvent":false,"participants":[],"free":true},{"id":2,"name":"Evento 2 modificato","user":{"uid":"0yISKL488gTvdPS1vckvyAoRwOu2","firstName":"Joel","email":"joel.sina97@gmail.com","profileImage":null,"bio":null,"type":1,"canCreatePublicEvent":false,"canSeeOthersProfile":true,"lastName":"Sina","birthDate":"04/08/1997"},"location":"SSM","date":"21/12/2019","description":null,"cancelled":false,"categoria":"Cat","maxNumber":8,"comments":[],"reviews":[],"partecipants":[],"publicEvent":false,"participants":[],"free":true},{"id":12,"name":"Evento 3","user":{"uid":"uEdGOvsfDCa2C9htEE4uOygp5BE3","firstName":"Comune San Severino Marche","email":"comune@ciao.com","profileImage":null,"bio":null,"type":2,"canCreatePublicEvent":true,"canSeeOthersProfile":false,"name":"Comune San Severino Marche"},"location":"SSM","date":"21/12/2019","description":null,"cancelled":false,"categoria":"Cat","maxNumber":8,"comments":[],"reviews":[],"partecipants":[],"publicEvent":true,"participants":[],"free":true},{"id":13,"name":"Kiss and say goodbye","user":{"uid":"0yISKL488gTvdPS1vckvyAoRwOu2","firstName":"Joel","email":"joel.sina97@gmail.com","profileImage":null,"bio":null,"type":1,"canCreatePublicEvent":false,"canSeeOthersProfile":true,"lastName":"Sina","birthDate":"04/08/1997"},"location":"San Severino Marche","date":"30/12/2019","description":null,"cancelled":false,"categoria":"Concerto","maxNumber":12,"comments":[],"reviews":[],"partecipants":[],"publicEvent":false,"participants":[],"free":true}]');
    if (response.statusCode == 200) {
      List<Event> events = [];
      List map = jsonDecode(response.toString());
      List events2 = map;
      events2.forEach((event) {
        events.add(Event.fromJson(event));
      });
      return events;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF5257F2),
      child: FutureBuilder<List<Event>>(
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Event event = snapshot.data.elementAt(index);
                print(event.name);
                return EventWidget(event: event);
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
        future: events,
      ),
    );
  }
}
