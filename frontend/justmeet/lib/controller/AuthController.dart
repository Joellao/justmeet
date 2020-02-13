import 'dart:io';

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

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

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
    if (user != null) {
      IdTokenResult token = await user.getIdToken();
      return token.token;
    }
    return null;
  }

  Future<DummyUser> signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      authProblems errorType;
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = authProblems.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = authProblems.NetworkError;
            break;
          default:
            print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            errorType = authProblems.UserNotFound;
            break;
          case 'Error 17009':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'Error 17020':
            errorType = authProblems.NetworkError;
            break;
          default:
            print('Case ${e.message} is not yet implemented');
        }
      }
      throw new Exception(errorType);
    }
  }

  Future<DummyUser> googleSignIn(GoogleSignInAccount login) async {
    GoogleSignInAuthentication auth = await login.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    // final AuthResult result =
    //     await FirebaseAuth.instance.signInWithCredential(credential);
    // FirebaseUser user = result.user;
    // await signOut();
    final AuthResult resultFasullo =
        await _auth.signInWithCredential(credential);
    String uid = resultFasullo.user.uid;
    signOut();
    String fullName = login.displayName;
    String username = login.email.substring(0, login.email.indexOf("@"));
    String name = login.displayName.substring(0, fullName.indexOf(" "));
    String surname = login.displayName.substring(fullName.indexOf(" ") + 1);
    String date = "01/01/1970";
    /*try {
      Response response = await dio.get(
        'https://people.googleapis.com/v1/people/${login.id}?personFields=birthdays',
        options: Options(headers: await login.authHeaders),
      );
      print(response.data);

      Map map = response.data['birthdays'][0]['date'];
      var day = map['day'];
      var month = map['month'];
      var year = map['year'];
      date = "$day/$month/$year";
      print(date);
    } on DioError catch (e) {
      print(e.response);
    }*/
    try {
      Response response = await dio.post(
        "https://justmeetgjj.herokuapp.com/signupUserGoogle",
        data: {
          'uid': uid,
          'email': login.email,
          'firstName': name,
          'lastName': surname,
          'userName': username,
          'date': date,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        AuthResult result =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return _userFromFirebase(result.user);
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return null;
  }

  Future<bool> signUpUser(SignupUser form) async {
    try {
      Response response =
          await dio.post("https://justmeetgjj.herokuapp.com/signupUser", data: {
        "email": form.email,
        "firstName": form.firstName,
        "lastName": form.lastName,
        "password": form.password,
        "birthDate": form.birthDate,
        "userName": form.userName
      });
      if (response.statusCode == 200) {
        print(response.data);
        return true;
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return false;
  }

  Future<bool> signUpInstitution(SignupInstitution form) async {
    Response response = await dio
        .post("https://justmeetgjj.herokuapp.com/signupInstitution", data: {
      "name": form.name,
      "email": form.email,
      "password": form.password,
      "userName": form.userName
    });
    if (response.statusCode == 200) {
      return true;
    }
    return false;
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
