
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

// user class to store a combination of times and locations for a user
class TimeLocation {

  final String bid;
  final DateTime start;
  final DateTime end;

  TimeLocation({this.bid, this.start, this.end});

  int totalTime () {
    return end.difference(start).inMinutes;
  }




}