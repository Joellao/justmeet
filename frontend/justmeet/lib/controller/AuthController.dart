import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
        if (response.data == "") return null;
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

  Future<DummyUser> googleSignIn(GoogleSignInAccount login) async {
    GoogleSignInAuthentication auth = await login.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    signOut();
    FirebaseUser user = result.user;
    String fullName = user.displayName;
    String username = user.email.substring(0, user.email.indexOf("@"));
    String name = user.displayName.substring(0, fullName.indexOf(" "));
    String surname = user.displayName.substring(fullName.indexOf(" ") + 1);
    String date;
    try {
      Response response = await dio.get(
        'https://people.googleapis.com/v1/people/${login.id}?personFields=birthdays',
        options: Options(headers: await login.authHeaders),
      );
      Map map = response.data['birthdays'][0]['date'];
      var day = map['day'];
      var month = map['month'];
      var year = map['year'];
      date = "$day/$month/$year";
      print(date);
    } on DioError catch (e) {
      print(e.response);
    }
    try {
      Response response = await dio
          .post("https://justmeetgjj.herokuapp.com/signupUserGoogle", data: {
        'uid': user.uid,
        'email': user.email,
        'firstName': name,
        'lastName': surname,
        'userName': username,
        'date': date,
      });

      if (response.statusCode == 200) {
        print(response.data);
        if (response.data == "") {
          FirebaseAuth.instance.signInWithCredential(credential);
        }
        return _userFromFirebase(user);
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return null;
  }

  Future<FirebaseUser> signUpUser(SignupUser form) async {
    Response response =
        await dio.post("https://justmeetgjj.herokuapp.com/signupUser", data: {
      "email": form.email,
      "firstName": form.firstName,
      "lastName": form.lastName,
      "password": form.password,
      "birthDate": form.birthDate,
      "userName": form.userName
    });
    if (response.statusCode == 401) {
      print(response.data);
      return response.data;
    }
    return null;
  }

  Future<FirebaseUser> signUpInstitution(SignupInstitution form) async {
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
