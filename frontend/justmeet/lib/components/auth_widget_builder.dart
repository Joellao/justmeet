import 'package:justmeet/components/models/user.dart';
import 'package:justmeet/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:justmeet/controller/UserController.dart';
import 'package:provider/provider.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<DummyUser>) builder;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthController>(context, listen: false);
    return StreamBuilder<DummyUser>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        final DummyUser user = snapshot.data;
        if (user != null) {
          return MultiProvider(
            providers: [
              FutureProvider<User>.value(
                value: AuthController().getUser(),
                catchError: (context, e) {
                  print(e);
                  return null;
                },
              ),
              FutureProvider<String>.value(
                value: AuthController().getToken(),
              ),
              Provider<UserController>(
                create: (_) => UserController(),
              )
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
