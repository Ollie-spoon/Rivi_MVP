import 'package:firebase_auth/firebase_auth.dart';
import 'package:rivi_mvp/models/models.dart';
import 'package:rivi_mvp/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebase object
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

//  // sign in anon
////  Future signInAnon() async {
////    try {
////      AuthResult result = await _auth.signInAnonymously();
////      FirebaseUser user = result.user;
////      return _userFromFirebaseUser(user);
////    } catch (e) {
////      print(e.toString());
////      return null;
////    }
////  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async{
    String errorMessage;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Email address is badly formatted";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "The password does not match this email";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled";
          break;
        default:
          errorMessage = "An undefined Error happened";
      }
      return errorMessage;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password, String name,) async{
    String errorMessage;
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).uploadUserData(email, name,);
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Email address is badly formatted";
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "#";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "User with this email already exists";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled";
          break;
        default:
          errorMessage = "An undefined Error happened";
      }
      return errorMessage;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}