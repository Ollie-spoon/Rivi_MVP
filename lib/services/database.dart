import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference for user data
  final CollectionReference userDataCollection = Firestore.instance.collection("UserData");

  Future uploadUserData(String email, String name,) async {
    return await userDataCollection.document(uid).setData({
      "email": email,
      "name": name,
    });
  }

  int convertDateTime(String dateTime) {
    dateTime = dateTime.substring(0, dateTime.length-10);
    dateTime = dateTime.replaceAll(" ", "");
    dateTime = dateTime.replaceAll("-", "");
    dateTime = dateTime.replaceAll(":", "");
    return int.parse(dateTime);
  }

  final DocumentReference userLocCollection2 = Firestore.instance.collection("LocationData").document("userData");

  Future uploadLocData(String locationKey, DateTime time, bool start,) async {
    int stringTime = convertDateTime(time.toUtc().toString());
    return await userLocCollection2.collection(uid)
        .document(locationKey).setData({
      "time": {stringTime, start ? "1" : "0"}.join(),
    });
  }


  Future uploadLocData2(String locationKey, DateTime time, bool start,) async {
    int stringTime = convertDateTime(time.toUtc().toString());
    try {
      return await userLocCollection2.collection(uid)
          .document(locationKey).updateData({"time": FieldValue.arrayUnion([stringTime]),});
    } catch(e) {print(e.toString());}
  }
}