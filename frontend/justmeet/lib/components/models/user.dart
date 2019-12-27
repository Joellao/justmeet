import 'package:flutter/material.dart';

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String profileImage;
  final String email;
  final String bio;
  final List events;

  const User({
    Key key,
    @required this.uid,
    @required this.firstName,
    @required this.lastName,
    @required this.birthDate,
    @required this.email,
    @required this.bio,
    @required this.events,
    @required this.profileImage,
  });

  User.fromJson(Map<String, dynamic> json)
      : this.uid = json['uid'],
        this.firstName = json['firstName'],
        this.lastName = json['lastName'] != null ? json['lastName'] : "",
        this.birthDate = json['birthDate'],
        this.email = json['email'],
        this.bio = json['bio'],
        this.events = json['events'],
        this.profileImage =
            json['profileImage'] == null ? "" : json['profileImage'];
}
