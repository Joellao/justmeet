import 'package:dio/dio.dart';

class ReportProblemController {
  Future<bool> reportProblem(String token, String body) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post(
        "https://justmeetgjj.herokuapp.com/report",
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
