import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      notifyListeners();
      return user;
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future logout() async {
    var result = _auth.signOut();
    notifyListeners();
    return result;
  }
}
