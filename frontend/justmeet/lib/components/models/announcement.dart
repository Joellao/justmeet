import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justmeet/components/models/user.dart';

class Announcement {
  final String name;
  final String category;
  final String date;
  final String description;
  final User user;
  final List comments;
  const Announcement({
    Key key,
    @required this.name,
    @required this.category,
    this.date,
    this.description,
    this.comments,
    this.user,
  });
  Announcement.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.category = json['category'],
        this.date =
            DateFormat("dd/MM/yyyy").format(DateTime.parse(json['date'])),
        this.description =
            json['description'] != null ? json['description'] : "",
        this.user = json['user'] != null ? User.fromJson(json['user']) : null,
        this.comments = json['comments'];
}