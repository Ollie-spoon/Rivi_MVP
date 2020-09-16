import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';


// user class to store the user id code in
class User {

  final String uid;

  User({this.uid});

}

// user class to store the beacon id code in
class Beacon {

  String bid;

  Beacon({this.bid});

}