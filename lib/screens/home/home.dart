import 'package:flutter/material.dart';
import 'package:rivi_mvp/models/models.dart';
import 'package:rivi_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:rivi_mvp/services/database.dart';
import 'package:rivi_mvp/shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {

  final String bid = "t1pw4cq85yn6h";
  // final String bid = "1jfw4o9g7y5ks"; // this is the alternate value for the beacon ID from the database

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamProvider<LocationList>.value(
      value: DatabaseService(uid: user.uid).lastEightHours,
      child: Scaffold(
          backgroundColor: homeColor,
          appBar: AppBar(
            elevation: 0,
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
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  RaisedButton(
                    child: Text(
                      " Upload start time for $bid",
                    ),
                    onPressed: () {
                      DatabaseService(uid: user.uid).uploadLocData(bid, roundDateTime(DateTime.now()), true,);
                    },
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    child: Text(
                      " Upload end time ",
                    ),
                    onPressed: () {
                      DatabaseService(uid: user.uid).uploadLocData(bid, roundDateTime(DateTime.now()), false,);
                    },
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    child: Text(
                      " Delete everything ",
                    ),
                    onPressed: () {
                      DatabaseService(uid: user.uid).deleteLocData(bid,);
                    },
                  ),
                  SizedBox(height: 20,),
                  LocationListButton(title: " places in the last eight hours ",),
                  SizedBox(height: 20,),
                  RaisedButton(
                    child: Text(
                      "Testing button",
                    ),
                    onPressed: () {
                      DatabaseService(uid: user.uid).covidUpload(DateTime.now(), true);
                    },
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    child: Text(
                      "People in the last Eight Hours",
                    ),
                    onPressed: () {
                      DatabaseService(uid: user.uid).peopleInLastEightHours(bid, Duration(hours: 8), true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

DateTime roundDateTime(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, 0,0, 0);
}

class LocationListButton extends StatelessWidget {
  final String title;
  LocationListButton({this.title});
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LocationList>(context);
    return RaisedButton(
      child: Text(title),
      onPressed: () {
        print(data.lList);
      },
    );
  }
}


