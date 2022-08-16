import 'package:flutter/material.dart';

const registerTextInput = InputDecoration(
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(const Radius.circular(18)),
      borderSide: BorderSide.none),
  // BorderSide // OutlineInput Bor
);

ButtonStyle registerElevatedButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
    backgroundColor: MaterialStateProperty.all(Colors.green));
