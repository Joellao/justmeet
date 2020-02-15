import 'package:dio/dio.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:provider/provider.dart';

class UserController {
  Dio dio = new Dio();

  Future<User> modifyUser(context, String username, String profileImage,
      String bio, String email, String uid) async {
    String token = Provider.of<String>(context, listen: false);
    Response response = await dio.put(
      "https://justmeetgjj.herokuapp.com/user/",
      data: {
        "username": username,
        "profileImage": profileImage,
        "bio": bio,
        "email": email
      },
      options: Options(
        headers: {
          "Authorization": token,
        },
        responseType: ResponseType.json,
      ),
    );
    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    }
    return null;
  }

  Future<User> getUser(context) async {
    String token = Provider.of<String>(context, listen: false);
    Response response = await dio.get(
      "https://justmeetgjj.herokuapp.com/user/",
      options: Options(
        headers: {
          "Authorization": token,
        },
        responseType: ResponseType.json,
      ),
    );
    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    }
    return null;
  }

  Future<List> searchUser(String token, String username) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.get(
        "https://justmeetgjj.herokuapp.com/user/$username/find",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return null;
  }

  Future<bool> acceptRequest(String token, String uid) async {
    try {
      Response response = await dio.patch(
        "https://justmeetgjj.herokuapp.com/user/$uid/true",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return false;
  }

  Future<bool> refuseRequest(String token, String uid) async {
    try {
      Response response = await dio.patch(
        "https://justmeetgjj.herokuapp.com/user/$uid/false",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return false;
  }
}
