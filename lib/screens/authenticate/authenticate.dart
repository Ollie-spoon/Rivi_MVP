import 'package:flutter/material.dart';
import 'package:rivi_mvp/screens/authenticate/register.dart';
import 'package:rivi_mvp/screens/authenticate/sign_in.dart';
import 'package:rivi_mvp/services/auth.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView () {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  // final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}