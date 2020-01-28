import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String uid;
  String firstName;
  String lastName;
  String birthDate;
  String profileImage;
  String email;
  String bio;
  List events;
  String username;
  List announcements;
  List friends;
  List friendRequests;
  List partecipatedEvents;
  User({
    Key key,
    @required this.uid,
    @required this.firstName,
    @required this.lastName,
    @required this.birthDate,
    @required this.email,
    @required this.bio,
    @required this.events,
    @required this.profileImage,
    @required this.username,
    @required this.announcements,
    @required this.partecipatedEvents,
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
            json['profileImage'] == null ? "" : json['profileImage'],
        this.username = json['userName'] == null ? "" : json['userName'],
        this.announcements = json['announcements'],
        this.friends = json['friends'] == null ? [] : json['friends'],
        this.friendRequests =
            json['requestFriends'] == null ? [] : json['requestFriends'],
        this.partecipatedEvents = json['partecipatedEvents'] == null
            ? []
            : json['partecipatedEvents'];

  void update(
      uid,
      firstName,
      lastName,
      birthDate,
      email,
      bio,
      events,
      profileImage,
      username,
      announcements,
      friends,
      friendRequests,
      partecipatedEvents) {
    this.uid = uid;
    this.firstName = firstName;
    this.lastName = lastName;
    this.birthDate = birthDate;
    this.profileImage = profileImage;
    this.email = email;
    this.bio = bio;
    this.events = events;
    this.username = username;
    this.announcements = announcements;
    this.friends = friends;
    this.friendRequests = friendRequests;
    this.partecipatedEvents = partecipatedEvents;
    notifyListeners();
  }
}
