import 'package:dio/dio.dart';

class ReviewController {
  Future<bool> deleteReview(String token, int id) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.delete(
        "https://justmeetgjj.herokuapp.com/review/$id",
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
