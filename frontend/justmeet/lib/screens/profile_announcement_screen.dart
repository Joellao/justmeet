import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/announcement.dart';
import 'package:justmeet/components/widgets/announcement_widget.dart';

class ProfileAnnouncementScreen extends StatelessWidget {
  final List<dynamic> announcements;

  const ProfileAnnouncementScreen({Key key, @required this.announcements})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        color: Colori.bluScuro,
        child: Builder(builder: (BuildContext context) {
          return CustomScrollView(
            key: this.key,
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverFixedExtentList(
                  itemExtent: 138.0,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Announcement announcement = Announcement.fromJson(
                          this.announcements.elementAt(index));
                      return AnnouncementWidget(
                        announcement: announcement,
                      );
                    },
                    childCount: this.announcements.length,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
