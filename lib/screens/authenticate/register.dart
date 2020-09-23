import 'package:flutter/material.dart';
import 'package:rivi_mvp/services/auth.dart';
import 'package:rivi_mvp/shared/colors.dart';
import 'package:rivi_mvp/shared/constants.dart';
import 'package:rivi_mvp/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String _password = "";
  String name = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: loginColor,
      appBar: AppBar(
        title: Text(
          "Sign up to Rivi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.7,
            color: primaryTextColor,
          ),
        ),
        backgroundColor: primaryColor,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign in"),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20,),
                TextFormField(
                  initialValue: name,
                  decoration: textInputDecoration("Name"),
                  validator: (val) {
                    return val.isEmpty ? "This is a required field" : null;
                  },
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  initialValue: email,
                  decoration: textInputDecoration("Email"),
                  validator: (val) {
                    return val.isEmpty ? "This is a required field" : null;
                  },
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  initialValue: _password,
                  decoration: textInputDecoration("password"),
                  validator: (val) {
                    return val.isEmpty ? "This is a required field" : null;
                  },
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      _password = val;
                    });
                  },
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    child: Text(
                      "Register",
                      style: buttonStyle(),
                    ),
                  ),
                  color: primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate() && validate(_password)) {
                      setState(() {
                        loading = true;
                      });
                      validate(_password);
                      dynamic result = await _auth.registerWithEmailAndPassword(email, _password, name,);
                      print(result.toString());
                      if (result.runtimeType == String) {
                        if (result == "#") {
                          result = "Please ensure password is 8+ characters long and includes:\n• An upper case character\n• Lower case character\n• Number\n• special character";
                        }
                        setState(() {
                          error = result;
                          loading = false;
                        });
                      }
                    }
                  },
                ),
                SizedBox(height: 20,),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool validate(String text) {
    if (!validateStructure(text)) {
      setState(() {
        error = "Please ensure password is 8+ characters long and includes:\n• An upper case character\n• Lower case character\n• Number\n• special character";
      });
      return false;
    }
    return true;
  }
}

bool validateStructure(String value){
  String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}
