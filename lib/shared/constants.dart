import 'package:flutter/material.dart';
import 'package:rivi_mvp/shared/colors.dart';

InputDecoration textInputDecoration(text) {
  return InputDecoration(
    hintText: text,
    fillColor: tertiaryColor,
    filled: true,
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: tertiaryColor, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2.0),
    ),
  );

}

TextStyle buttonStyle() {
  return TextStyle(
      color: primaryTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 18
  );
}