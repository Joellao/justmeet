import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justmeet/components/models/announcement.dart';
import 'package:justmeet/screens/announcement_screen.dart';

class AnnouncementWidget extends StatefulWidget {
  final Announcement announcement;
  final Widget profileWidget;

  const AnnouncementWidget({Key key, this.announcement, this.profileWidget})
      : super(key: key);
  @override
  _AnnouncementWidgetState createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnnouncementScreen(
            announce: this.widget.announcement,
          ),
        ),
      ),
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
              widget.profileWidget != null ? widget.profileWidget : SizedBox(),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        "https://apprecs.org/ios/images/app-icons/256/ca/644106186.jpg",
                        height: 90,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.announcement.name,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          widget.announcement.description != ""
                              ? Text(
                                  widget.announcement.description,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : SizedBox(),
                        ]),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
