import 'package:flutter/material.dart';
import 'package:rivi_mvp/services/auth.dart';
import 'package:rivi_mvp/shared/colors.dart';
import 'package:rivi_mvp/shared/constants.dart';
import 'package:rivi_mvp/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: loginColor,
      appBar: AppBar(
        title: Text(
          "Sign in to Rivi",
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
            label: Text("Register"),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              TextFormField(
                initialValue: email,
                decoration: textInputDecoration("Email"),
                // decoration: textInputDecoration.copyWith(hintText: "Email"),
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
                child: Text(
                  "Sign in",
                  style: buttonStyle(),
                ),
                color: primaryColor,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = "Email and password not found";
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
    );
  }
}


// basic login
// email: omn22@bath.ac.uk
// password: 07508670194