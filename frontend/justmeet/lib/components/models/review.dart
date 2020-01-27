import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';

class Review {
  final int id;
  final User user;
  final Event event;
  final String body;
  final String date;
  final int stars;

  const Review({
    Key key,
    @required this.body,
    @required this.stars,
    this.date,
    this.event,
    this.user,
    this.id,
  });

  Review.fromJson(Map<String, dynamic> json)
      : this.body = json['body'],
        this.stars = json['stars'],
        this.id = json['id'],
        this.date =
            DateFormat("dd/MM/yyyy").format(DateTime.parse(json['date'])),
        this.user = json['user'] != null ? User.fromJson(json['user']) : null,
        this.event =
            json['event'] != null ? Event.fromJson(json['user']) : null;
}
