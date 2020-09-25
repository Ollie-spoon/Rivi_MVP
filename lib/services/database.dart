import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rivi_mvp/models/models.dart';

class DatabaseService {

  final String uid;
  Duration duration;

  DatabaseService({this.uid = null, this.duration = const Duration(hours: 8)});

  // try {} catch(e) {print(e.toString());}
  // collection reference for user data
  final CollectionReference userDataCollection = Firestore.instance.collection("UserData");

  // function used on creation of an account to upload a users email and name to Firebase
  Future uploadUserData(String email, String name,) async {
    return await userDataCollection.document(uid).setData({
      "email": email,
      "name": name,
    });
  }


  // ALL OF THE FOLLOWING FUNCTIONS AND STREAMS ARE CURRENTLY IMPLEMENTED AS BUTTONS ON THE HOME SCREEN


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


  // stream to locations that you've been to in the last $duration
  Stream<LocationList> get lastEightHours {
    return userLocCollection.document(uid).snapshots().map(_lastEightHoursFromSnapshot);
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

  // command to get the people that have visited a location in the last $duration
  Future peopleInLastEightHours(String locationKey, bool start) async {
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

  final CollectionReference random = Firestore.instance.collection("RandomData");
  final CollectionReference covid = Firestore.instance.collection("COVIDData");

  // this function generates random time data for all of the people listed in all of the places listed sequentially
  Future uploadRandomData(DateTime startTime) async {
    List<String> people = ["Tracy", "Steve", "Wendy", "Matt", "Ollie", "Mari-Megan"];
    /*List<String> places = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii",
      "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
      "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
      "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
      "Washington", "West Virginia", "Wisconsin", "Wyoming"];*/
    List<String> places = ["Alabama", "Alaska", "Arizona", "Arkansas"];
    DateTime originalStartTime = startTime;
    DateTime endTime;
    for (String person in people) {
      startTime = originalStartTime;
      Map<String, List<dynamic>> map = {};
      DocumentReference document = random.document(person);
      for (String place in places) {
        for (int i = 0; i < 3; i++) {
          double randomNumber = Random().nextDouble();
          if (randomNumber > 0.5) {
            startTime = startTime.add(Duration(minutes: (randomNumber*60).floor()));
            endTime = startTime.add(Duration(minutes: Random().nextInt(180)));
            Map<String, DateTime> timeMap = {"start": startTime, "end": endTime};
            if (map[place] == null) {
              map[place] = [timeMap];
            } else {
              map[place].add(timeMap);
            }
            startTime = endTime;
          }
        }
      }
      document.setData(map);
    }
  }

  // this function cross references your locationTime data with the directory containing location Time data for symptomatic individuals
  void doIHaveCovid (Map<String, List<dynamic>> covidMap, Map<String, List<dynamic>> myMap) {
    print("RUNNING CHECK FOR CONTACT WITH SYMPTOMATIC INDIVIDUALS!!!");
    int covidContacts = 0;
    covidMap.forEach((key, value) {
      if (myMap[key] != null) {
        for (Map myStartEndMaps in myMap[key]) {
          for (Map covidStartEndMaps in value) {
            if (myStartEndMaps["start"].isBefore(covidStartEndMaps["end"]) && myStartEndMaps["end"].isAfter(covidStartEndMaps["start"])) {
              print("Interaction with a symptomatic individual at $key.");
              print("You were there between ${myStartEndMaps["start"]} and ${myStartEndMaps["end"]}.");
              print("They were there between ${covidStartEndMaps["start"]} and ${covidStartEndMaps["end"]}.");
              covidContacts++;
            }
          }
        }
      }
    });
    print("IN TOTAL YOU CAME INTO CONTACT WITH SYMPTOMATIC INDIVIDUALS $covidContacts TIMES.");
  }

  Future iHaveCovid (String name) async {
    DocumentReference document = random.document(name);
    DocumentReference covidDocument = covid.document("ConfirmedCases");
    await covidDocument.get().then((covidValue) {
      print(covidValue.data);
      Map<String, dynamic> covidMap = covidValue.data;
      document.get().then((myValue) {
        print(myValue.data);
        if (covidValue.data == null) {
          covidDocument.setData(myValue.data);
        } else {
          myValue.data.forEach((_myKey, _myValue) {
            if (!covidMap.containsKey(_myKey)) {
              covidMap[_myKey] = _myValue;
            }
            covidMap.forEach((key, value) {
              for (Map myStartEndMaps in myValue.data[key]) {
                int i = 0;
                for (Map covidStartEndMaps in value) {
                  if (myStartEndMaps["start"].seconds < covidStartEndMaps["end"].seconds && myStartEndMaps["end"].seconds > covidStartEndMaps["start"].seconds) {
                    if (myStartEndMaps["start"].seconds < covidStartEndMaps["start"].seconds) {
                      covidMap[key][i]["start"] = myStartEndMaps["start"];
                    }
                    if (myStartEndMaps["end"].seconds > covidStartEndMaps["end"].seconds) {
                      covidMap[key][i]["end"] = myStartEndMaps["end"];
                    }
                  }
                  i++;
                }
              }
            });
          }) ;
          //covidDocument.setData(covidMap);
          print(covidMap);
        }
      });
    });
  }
}