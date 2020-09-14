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
  String password = "";
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
                  initialValue: password,
                  decoration: textInputDecoration("Password"),
                  validator: (val) {
                    return val.length < 6 ? "Enter password 6+ chars long" : null;
                  },
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      password = val;
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
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password, name,);
                      if (result == null) {
                        setState(() {
                          error = "Please supply valid email";
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
}
