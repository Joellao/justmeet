import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/request_widget.dart';

class RequestFriendsScreen extends StatefulWidget {
  final List<dynamic> requests;
  const RequestFriendsScreen({Key key, this.requests}) : super(key: key);

  @override
  _RequestFriendsState createState() => _RequestFriendsState();
}

class _RequestFriendsState extends State<RequestFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colori.bluScuro,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: this.widget.requests.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user =
                        User.fromJson(this.widget.requests.elementAt(index));
                    return RequestWidget(
                      user: user,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
