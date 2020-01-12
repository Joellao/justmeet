import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/config.dart';
import 'package:justmeet/components/models/user.dart';

@immutable
class DummyUser {
  const DummyUser({@required this.uid});
  final String uid;
}

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> getUser() async {
    Dio dio = new Dio();
    FirebaseUser fbUser = await _auth.currentUser();
    IdTokenResult token = await fbUser.getIdToken();
    Response response = await dio.get(
      "https://justmeetgjj.herokuapp.com/user",
      options: Options(
        headers: {
          "Authorization": token.token,
        },
        responseType: ResponseType.json,
      ),
    );
    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    }
    return null;
  }

  Future<String> getToken() async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();
    return token.token;
  }

  Future<DummyUser> signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  DummyUser _userFromFirebase(FirebaseUser user) {
    return user == null ? null : DummyUser(uid: user.uid);
  }

  Stream<DummyUser> get onAuthStateChanged {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
