import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class MyUser {
  final String uid;
  MyUser({required this.uid});
}

class Students {
  String uid;
  String username;

  Students({
    required this.uid,
    required this.username,
  });
}

class Tutors {
  String uid;
  String username;
  String name;
  String about;
  String photofilepath;
  List languages;
  List skills;

  Tutors({
    required this.uid,
    required this.username,
    required this.name,
    required this.about,
    required this.photofilepath,
    required this.languages,
    required this.skills,
  });
}
