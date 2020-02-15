import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:justmeet/components/models/creates/CommentCreate.dart';
import 'package:justmeet/components/models/creates/EventCreate.dart';
import 'package:justmeet/components/models/creates/ReviewCreate.dart';

class EventController {
  Future<LinkedHashMap<String, dynamic>> createEvent(
      String token, EventCreate create) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post(
        "https://justmeetgjj.herokuapp.com/event",
        data: {
          "name": create.name,
          "location": create.location,
          "description": create.description,
          "isFree": create.isFree,
          "category": create.category.toUpperCase(),
          "maxPersons": create.maxPersons,
          'date': create.date
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

  Future<LinkedHashMap<String, dynamic>> editEvent(
      String token, int id, EventCreate create) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.put(
        "https://justmeetgjj.herokuapp.com/event/$id",
        data: {
          "name": create.name,
          "location": create.location,
          "description": create.description,
          "isFree": create.isFree,
          "category": create.category.toUpperCase(),
          "maxPersons": create.maxPersons,
          'date': create.date
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

  Future<bool> deleteEvent(String token, int id) async {
    print("Entrato");
    try {
      Dio dio = new Dio();
      Response response = await dio.delete(
        "https://justmeetgjj.herokuapp.com/event/$id",
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

  Future<bool> cancelEvent(String token, int id) async {
    print("Entrato");
    try {
      Dio dio = new Dio();
      Response response = await dio.patch(
        "https://justmeetgjj.herokuapp.com/event/$id",
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

  Future<LinkedHashMap<String, dynamic>> commentEvent(
      String token, int eventId, CommentCreate create) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post(
        "https://justmeetgjj.herokuapp.com/event/$eventId/comment",
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

  Future<List> findEvent(String token, String eventName) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.get(
        "https://justmeetgjj.herokuapp.com/event/$eventName/find",
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

  Future<bool> partecipateEvent(String token, int id) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post(
        "https://justmeetgjj.herokuapp.com/event/$id/prenote",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        if (response.data) {
          print("Prenotazione effettuata con successo");
        } else {
          print("errore");
        }
        return true;
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return false;
  }

  Future<bool> cancelPartecipateEvent(String token, int id) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.patch(
        "https://justmeetgjj.herokuapp.com/event/$id/cancelPrenote",
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

  Future<LinkedHashMap<String, dynamic>> reviewEvent(
      String token, int id, ReviewCreate create) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post(
        "https://justmeetgjj.herokuapp.com/event/$id/review",
        data: {
          "body": create.body,
          "stars": create.stars,
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
