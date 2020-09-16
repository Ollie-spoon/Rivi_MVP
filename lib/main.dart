import 'package:flutter/material.dart';
import 'package:rivi_mvp/models/user.dart';
import 'package:rivi_mvp/screens/wrapper.dart';
import 'package:rivi_mvp/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          );
        },
        home: Wrapper(),
        title: "Rivi",
      ),
    );
  }
}

// this removes blue glow when scrolling
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}