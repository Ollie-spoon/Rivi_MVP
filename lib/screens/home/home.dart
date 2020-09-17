import 'package:flutter/material.dart';
import 'package:rivi_mvp/models/models.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  "Check locations in the last eight hours",
                ),
                onPressed: () {
                  getTimeLocations(user.uid);
                },
              ),
              SizedBox(height: 30,),
              RaisedButton(
                child: Text(
                  " Upload start time ",
                ),
                onPressed: () {
                  DatabaseService(uid: user.uid).uploadLocData3("9tp1WC4qY3nH", roundDateTime(DateTime.now()), true,);
                },
              ),
              SizedBox(height: 30,),
              RaisedButton(
                child: Text(
                  " Upload end time ",
                ),
                onPressed: () {
                  DatabaseService(uid: user.uid).uploadLocData3("9tp1WC4qY3nH", roundDateTime(DateTime.now()), false,);
                },
              ),
              SizedBox(height: 30,),
              RaisedButton(
                child: Text(
                  " Delete everything ",
                ),
                onPressed: () {
                  DatabaseService(uid: user.uid).deleteLocData("9tp1WC4qY3nH",);
                },
              ),
            ],
          ),
        ),
      );
  }
}

List<TimeLocation> getTimeLocations (String uid) {
  TimeLocation x = TimeLocation(start: roundDateTime(DateTime.now().subtract(Duration(hours: 8,))), end: roundDateTime(DateTime.now()));
  print("end of ${x.end} - start of ${x.start} = ${x.totalTime()} minutes");
  return [x];
}

DateTime roundDateTime(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, 0,0, 0);
}