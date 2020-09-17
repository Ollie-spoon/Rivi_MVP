import 'package:flutter/material.dart';
import 'package:rivi_mvp/models/models.dart';
import 'package:rivi_mvp/screens/authenticate/authenticate.dart';
import 'package:rivi_mvp/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return wither Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}