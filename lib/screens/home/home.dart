import 'package:flutter/material.dart';
import 'package:rivi_mvp/services/auth.dart';
// TODO: remove provider plugin if not needed
import 'package:provider/provider.dart';
import 'package:rivi_mvp/shared/colors.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text(
          "Rivi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 36,
            letterSpacing: 2,
            color: primaryTextColor,
          ),
        ),
        backgroundColor: primaryColor,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("logout"),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}