import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userDataCollection = Firestore.instance.collection("UserData");

  Future uploadUserData(String email, String name,) async {
    return await userDataCollection.document(uid).setData({
      "email": email,
      "name": name,
    });
  }

}