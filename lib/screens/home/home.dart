import 'package:flutter/material.dart';
import 'package:rivi_mvp/models/user.dart';
import 'package:rivi_mvp/services/auth.dart';
// TODO: remove provider plugin if not needed
import 'package:provider/provider.dart';
import 'package:rivi_mvp/services/database.dart';
import 'package:rivi_mvp/shared/colors.dart';
import 'package:rivi_mvp/shared/constants.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<User>(
      stream: AuthService().user,
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
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30,),
                RaisedButton(
                  child: Text(
                    "Add start time to firebase",
                    style: buttonStyle(),
                  ),
                  onPressed: () async {
                    try {
                      await DatabaseService(uid: user.uid,).uploadLocData2("9tp1WC4qY3nH", DateTime.now(), true);
                      print("DatetimeLoc added to firebase");
                    } catch(e) {print(e.toString());}
                  },
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  child: Text(
                    "Add end time to firebase",
                    style: buttonStyle(),
                  ),
                  onPressed: () async {
                    try {
                      await DatabaseService(uid: user.uid,).uploadLocData2("9tp1WC4qY3nH", DateTime.now(), false);
                      print("DatetimeLoc added to firebase");
                    } catch(e) {print(e.toString());}
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}