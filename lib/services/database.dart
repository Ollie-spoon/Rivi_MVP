import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rivi_mvp/models/models.dart';

class DatabaseService {

  final String uid;
  Duration duration = Duration(hours: 8);

  DatabaseService({this.uid});

  // try {} catch(e) {print(e.toString());}
  // collection reference for user data
  final CollectionReference userDataCollection = Firestore.instance.collection("UserData");

  Future uploadUserData(String email, String name,) async {
    return await userDataCollection.document(uid).setData({
      "email": email,
      "name": name,
    });
  }

  // collection reference for location data
  final CollectionReference userLocCollection = Firestore.instance.collection("LocationData");

  // command to delete your location document
  Future deleteLocData(String locationKey,) async {
    try {
      return await userLocCollection.document(uid).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // command to upload location time data to firebase
  Future uploadLocData(String locationKey, DateTime time, bool start) async {
    if (uid == null) {
      print("ERROR: uid == null");
      return;
    }
    DocumentReference dbLocation = userLocCollection.document(uid);
    try {
      await dbLocation.get().then((value) {
        if ((!value.exists) & start) {
          dbLocation.setData({locationKey: FieldValue.arrayUnion([{"start": time, "end": null,},])});
        } else {
          List<dynamic> timeList = value.data[locationKey];
          if ((timeList == null) & start) {
            dbLocation.setData({locationKey: FieldValue.arrayUnion([{"start": time, "end": null,},])}, merge: true);
          } else {
            int last = timeList.length-1;
            if ((timeList[last]["end"] == null) & (!start)) {
              dbLocation.updateData({locationKey: FieldValue.arrayRemove([timeList[last]])});
              dbLocation.updateData({locationKey: FieldValue.arrayUnion([{"start": timeList[last]["start"], "end": time,}])});
            }
            if (start) {
              dbLocation.setData({locationKey: FieldValue.arrayUnion([{"start": time, "end": null,},])}, merge: true);
            }
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // formatting for the stream to get locations that you've been to in the last $duration
  LocationList _lastEightHoursFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null) {
      return null;
    }
    List<String> locations = [];
    try {
      snapshot.data.forEach((key, value) {
        Timestamp latest = value[value.length-1]["end"];
        if (latest == null) {
          locations.add(key);
        } else {
          if (DateTime.fromMillisecondsSinceEpoch(latest.seconds*1000).isAfter(DateTime.now().subtract(duration))) {
            locations.add(key);
          }}
      });
    } catch(e) {}
    return LocationList(lList: locations);
  }

  // stream to locations that you've been to in the last $duration
  Stream<LocationList> get lastEightHours {
    return userLocCollection.document(uid).snapshots().map(_lastEightHoursFromSnapshot);
  }

  // this is the "I HAVE COVID-19" button
//  Future covidUpload(String locationKey, DateTime time, bool start) async {
//    if (uid == null) {
//      print("ERROR: uid == null");
//      return;
//    }
//    DocumentReference dbLocation = Firestore.instance.collection("PositiveCases").document("Locations");
//    try {
//      await dbLocation.get().then((covValue) async {
//        if (covValue == null) {
//          await userLocCollection.document(uid).get().then((value) {
//            if (value == null) {return null;}
//            dbLocation.setData(value.data);
//          });
//        }
//        else{
//          if ()
//        }
//      });
//    } catch (e) {
//      print(e.toString());
//    }
//  }

  // collection reference for testing data
  final CollectionReference updateCollectionTesting = Firestore.instance.collection("TestingData");

  Future covidUpload(DateTime time, bool start) async {
    DocumentReference document = updateCollectionTesting.document("document");
    await document.setData(
        {"spring1": FieldValue.arrayUnion(
          ["EFT", "ELZ"]
        )}, merge: true,
        );
    print('"covidUpload" complete.');
  }

  // command to upload location time data to firebase
  Future peopleInLastEightHours(String locationKey, Duration duration, bool start) async {
    int i;
    DateTime endTime;
    DateTime time = DateTime.now().subtract(duration);
    List<String> peopleList = [];
    try {
      await userLocCollection.getDocuments().then((document) {
        document.documents.forEach((element) {
          i = 0;
          while (i < 1) {
            element.data.forEach((key, value) {
              try {
                endTime = DateTime.fromMillisecondsSinceEpoch(value[value.length-1]["end"].seconds*1000);
              } catch(e) {
                endTime = null;
              }
              if (key == locationKey && (endTime == null || endTime.isAfter(time))) {
                peopleList.add(element.documentID);
                i++;
              }
            });
            i = 1;
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
    print(peopleList);
  }
}