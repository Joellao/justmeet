import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:justmeet/components/models/creates/AnnouncementCreate.dart';

class AnnouncementController {
  Future<LinkedHashMap<String, dynamic>> newAnnouncement(
      String token, AnnouncementCreate create) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post(
        "https://justmeetgjj.herokuapp.com/announcement",
        data: {
          "name": create.name,
          "description": create.description,
          "category": create.category.toUpperCase(),
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

  Future<LinkedHashMap<String, dynamic>> editAnnouncement(
      String token, int id, AnnouncementCreate create) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.put(
        "https://justmeetgjj.herokuapp.com/announcement/$id",
        data: {
          "name": create.name,
          "description": create.description,
          "category": create.category.toUpperCase(),
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

  Future<bool> deleteAnnouncement(String token, int id) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.delete(
        "https://justmeetgjj.herokuapp.com/announcement/$id",
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

  Future<LinkedHashMap<String, dynamic>> commentAnnouncement(
      String token, int id, String body) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post(
        "https://justmeetgjj.herokuapp.com/announcement/$id/comment",
        data: {
          "body": body,
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
}
