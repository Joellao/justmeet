import 'package:flutter/material.dart';

class EventPhoto {
  final int id;
  final String url;
  //final User user;
  final String date;
  const EventPhoto({
    Key key,
    @required this.id,
    @required this.url,
    //@required this.user,
    this.date,
  });
  EventPhoto.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.url = json['url'],
        // this.user = User.fromJson(json['user']),
        this.date = json['date'];
}
