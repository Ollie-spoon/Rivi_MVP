import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rivi_mvp/models/models.dart';
import 'package:rivi_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:rivi_mvp/services/database.dart';
import 'package:rivi_mvp/shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  List<Message> _messages;

  _getToken() {
    _fcm.getToken().then((value) => print("Device token: $value"));
  }

  _configureFirebaseListeners() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _setMessage(message);
      },
    );
  }

  final String bid = "t1pw4cq85yn6h";

  final AuthService _auth = AuthService();

  _setMessage (Map<String, dynamic> message) {
    final notification = message["notification"];
    final data = message["data"];
    final title = notification["title"];
    final body = notification["body"];
    final messageData = data["Message_key"];
    Message m = Message(title: title, body: body, message: messageData);
    setState(() {
      _messages.add(m);
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messages = List<Message>();
    _getToken();
    _configureFirebaseListeners();
  }

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
                      DatabaseService(uid: user.uid).peopleInLastEightHours(bid, true);
                    },
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    child: Text(
                      "Upload random data",
                    ),
                    onPressed: () {
                      DatabaseService(uid: user.uid).uploadRandomData(roundDateTime(DateTime.now().subtract(Duration(days: 1))));
                    },
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    child: Text(
                      "I have COVID",
                    ),
                    onPressed: () {
                      DatabaseService(uid: user.uid).iHaveCovid("Ollie");
                    },
                  ),
                  SizedBox(height: _messages == null? 0 : 20,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: _messages == null? 0 : _messages.length*60.0,
                    child: ListView.builder(
                      itemCount: _messages == null? 0 : _messages.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              _messages[index].message,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  //SizedBox(height: 160,),
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

class Message {
  String title;
  String body;
  String message;
  Message({this.title, this.body, this.message});
}
