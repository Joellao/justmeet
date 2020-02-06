import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/models/review.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/star_rating.dart';
import 'package:justmeet/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class ReviewWidget extends StatefulWidget {
  final Review review;
  //final Widget profileWidget;
  final int index;
  final Function func;

  const ReviewWidget({Key key, this.review, this.index, this.func})
      : super(key: key);
  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  Future<bool> _deleteReview() async {
    try {
      Dio dio = new Dio();
      String token = Provider.of<String>(context, listen: false);
      Response response = await dio.delete(
        "https://justmeetgjj.herokuapp.com/review/${this.widget.review.id}",
        options: Options(
          headers: {
            "Authorization": token,
          },
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);
        print("Recensione eliminata");
        return true;
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Card(
          elevation: 4,
          color: Color(0XFFe1e2ef),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: <Widget>[
              getProfileWidget(this.widget.review.user),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 10),
                          Text(
                            this.widget.review.date,
                          ),
                          SizedBox(height: 10),
                          IconTheme(
                            data: IconThemeData(
                              color: Colors.amber,
                              size: 40,
                            ),
                            child: StarDisplay(value: this.widget.review.stars),
                          ),
                          Text(
                            widget.review.body,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ]),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getProfileWidget(User user) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: user)),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: user.profileImage != ""
                      ? NetworkImage(user.profileImage)
                      : null,
                  child: user.profileImage == ""
                      ? Icon(Icons.person, size: 25)
                      : null,
                ),
                SizedBox(
                  width: 7.0,
                ),
                Text(
                  user.firstName,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.lastName,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          PopupMenuButton<int>(
            icon: Icon(
              Icons.more_vert,
              size: 30.0,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 2,
                child: InkWell(
                  child: Text("Cancella recensione"),
                  onTap: () {
                    if (_deleteReview() != null) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Recensione cancellato"),
                      ));
                      this.widget.func(true, this.widget.index);
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
