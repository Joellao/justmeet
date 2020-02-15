import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:justmeet/components/models/creates/CommentCreate.dart';

class CommentController {
  Future<LinkedHashMap<String, dynamic>> editComment(
      String token, int id, CommentCreate create) async {
    print("Entrato");
    try {
      Dio dio = new Dio();
      Response response = await dio.put(
        "https://justmeetgjj.herokuapp.com/comment/$id",
        data: {
          "body": create.body,
        },
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

  Future<bool> deleteComment(String token, int id) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.delete(
        "https://justmeetgjj.herokuapp.com/comment/$id",
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

  Future<bool> reportComment(String token, int id, String body) async {
    print("Entrato");

    try {
      Dio dio = new Dio();
      Response response = await dio.post(
        "https://justmeetgjj.herokuapp.com/comment/$id",
        queryParameters: {'body': body},
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
