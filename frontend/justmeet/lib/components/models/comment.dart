import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justmeet/components/models/user.dart';

class Comment {
  final int id;
  final String body;
  final String date;
  User user;

  Comment({Key key, this.body, this.date, this.id, this.user});
  Comment.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.body = json['body'],
        this.date =
            DateFormat("dd/MM/yyyy").format(DateTime.parse(json['date'])),
        this.user = json['user'] != null ? User.fromJson(json['user']) : null;
}
