import 'package:flutter/material.dart';
import 'package:justmeet/components/colori.dart';
import 'package:justmeet/components/models/event.dart';
import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/components/widgets/event_widget.dart';
import 'package:provider/provider.dart';

class ProfileEventScreen extends StatelessWidget {
  final List<dynamic> events;

  const ProfileEventScreen({Key key, @required this.events}) : super(key: key);
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
                  itemExtent: 204.0,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Event event =
                          Event.fromJson(this.events.elementAt(index));
                      event.user = Provider.of<User>(context);
                      return EventWidget(
                        event: event,
                      );
                    },
                    childCount: this.events.length,
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
