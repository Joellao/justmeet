import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justmeet/components/models/user.dart';

class Event {
  final String name;
  final String location;
  final String category;
  final String date;
  final String description;
  final int maxNumber;
  final User user;
  final List comments;
  final List reviews;
  final List partecipants;
  final bool cancelled;
  const Event({
    Key key,
    @required this.name,
    @required this.location,
    @required this.category,
    @required this.maxNumber,
    this.date,
    this.description,
    this.comments,
    this.reviews,
    this.partecipants,
    this.cancelled,
    this.user,
  });
  Event.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.location = json['location'],
        this.category = json['category'],
        this.date =
            DateFormat("dd/MM/yyyy").format(DateTime.parse(json['date'])),
        this.description =
            json['description'] != null ? json['description'] : "",
        this.maxNumber = json['maxNumber'],
        this.user = json['user'] != null ? User.fromJson(json['user']) : null,
        this.comments = json['comments'],
        this.reviews = json['reviews'],
        this.partecipants = json['partecipants'],
        this.cancelled = json['cancelled'];
}
