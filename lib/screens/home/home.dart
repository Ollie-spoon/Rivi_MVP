import 'package:flutter/material.dart';
import 'package:rivi_mvp/models/user.dart';
import 'package:rivi_mvp/screens/home/beacon_list.dart';
import 'package:rivi_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:rivi_mvp/services/database.dart';
import 'package:rivi_mvp/shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamProvider<List<Beacon>>.value(
        value: DatabaseService().brews,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: homeColor,
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
            body: BeaconList(),
          );
        }
    );
  }
}