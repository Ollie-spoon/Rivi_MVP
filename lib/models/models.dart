
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

// user class to store a list of locations in a duration
class LocationList {

  final List<String> lList;
  final Duration duration;

  LocationList({this.lList, this.duration});

}