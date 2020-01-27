import 'package:dio/dio.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:provider/provider.dart';

class UserController {
  Dio dio = new Dio();

  Future<User> modifyUser(context, String username, String profileImage,
      String bio, String email, String uid) async {
    String token = Provider.of<String>(context, listen: false);
    Response response = await dio.put(
      "https://justmeetgjj.herokuapp.com/user/$uid",
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
}
