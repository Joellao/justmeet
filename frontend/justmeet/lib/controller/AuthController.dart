import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/models/creates/SignupInstitution.dart';
import 'package:justmeet/components/models/creates/SignupUser.dart';
import 'package:justmeet/components/models/user.dart';

@immutable
class DummyUser {
  const DummyUser({@required this.uid});
  final String uid;
}

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Dio dio = new Dio();
  Future<User> getUser() async {
    FirebaseUser fbUser = await _auth.currentUser();

    if (fbUser == null) {
      return null;
    }
    IdTokenResult token = await fbUser.getIdToken();
    try {
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
        if(response.data=="")
        return null;
        return User.fromJson(response.data);
      }
      if (response.statusCode == 500) {
        print("Ciao");
      }
    } on DioError catch (e) {
      print(e);
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
      throw new Exception(e);
    }
  }

  Future<FirebaseUser> signUpUser(SignupUser form) async {
    print("ciao2");
    Response response =
        await dio.post("https://justmeetgjj.herokuapp.com/signupUser", data: {
      "email": form.email,
      "firstName": form.firstName,
      "lastName": form.lastName,
      "password": form.password,
      "birthDate": form.birthDate,
      "userName": form.userName
    });
    print("ciao");
    if (response.statusCode == 401) {
      print(response.data);
      return response.data;
    }
    return null;
  }

  Future<FirebaseUser> signUpInstitution(SignupInstitution form) async {
    print("entrato");
    Response response = await dio
        .post("https://justmeetgjj.herokuapp.com/signupInstitution", data: {
      "name": form.name,
      "email": form.email,
      "password": form.password,
      "userName": form.userName
    });
    if (response.statusCode == 401) {
      return response.data;
    }
    return null;
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
