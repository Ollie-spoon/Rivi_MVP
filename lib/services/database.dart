import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rivi_mvp/models/models.dart';

class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  // try {} catch(e) {print(e.toString());}
  // collection reference for user data
  final CollectionReference userDataCollection = Firestore.instance.collection(
      "UserData");

  Future uploadUserData(String email, String name,) async {
    return await userDataCollection.document(uid).setData({
      "email": email,
      "name": name,
    });
  }

  final DocumentReference userLocCollection2 = Firestore.instance.collection("LocationData").document("userData");

  Future uploadLocData(String locationKey, DateTime time, bool start,) async {
    String startString = start ? "start" : "end";
    try {
      print("If this is all you can see then it has worked");
      return await userLocCollection2.collection(uid)
          .document(locationKey).setData(
          {startString: FieldValue.arrayUnion([time.toUtc()]),});
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadLocData2(String locationKey, DateTime time, bool start,) async {
    String startString = start ? "start" : "end";
    String _startString = start ? "end" : "start";
    DocumentReference dbLocation = userLocCollection2.collection(uid).document(locationKey);
    try {
      await dbLocation.get().then((value) {
        if (value.exists) {
          print(value.data);
          List<dynamic> timeList = value.data[locationKey];
          int last = timeList.length-1;
          if (timeList[last]["end"] == null) {
            timeList[last] = {startString: timeList[last]["start"], _startString: time.toUtc(),};
            dbLocation.setData({locationKey: FieldValue.arrayUnion(timeList)});
          }
        } else {
          dbLocation.setData({locationKey: FieldValue.arrayUnion([{startString: time.toUtc(), _startString: null,},])});
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteLocData(String locationKey,) async {
    try {
      return await userLocCollection2.collection(uid).document(locationKey).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadLocData3(String locationKey, DateTime time, bool start) async {
    DocumentReference dbLocation = userLocCollection2.collection(uid).document(locationKey);
    try {
      await dbLocation.get().then((value) {
        if ((!value.exists) & start) {
          dbLocation.setData({locationKey: FieldValue.arrayUnion([{"start": time.toUtc(), "end": null,},])});
        } else {
          List<dynamic> timeList = value.data[locationKey];
          int last = timeList.length-1;
          if ((timeList[last]["end"] == null) & (!start)) {
            timeList[last] = {"start": timeList[last]["start"], "end": time.toUtc(),};
            dbLocation.setData({locationKey: FieldValue.arrayUnion(timeList)});
          }
          if (start) {
            timeList.add({"start": time.toUtc(), "end": null,});
            dbLocation.updateData({locationKey: FieldValue.arrayUnion(timeList)});
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}