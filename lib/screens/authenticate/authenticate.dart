import 'package:flutter/material.dart';
import 'package:studently/screens/authenticate/login_page.dart';
import 'package:studently/screens/authenticate/register/registerTutor.dart';
import 'package:studently/screens/authenticate/register/registerWrapper.dart';
import 'package:studently/screens/studentScreens/profileStudent.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginPage(toggleView: toggleView);
      //return RegisterTutor();
    } else {
      return RegisterWrapper(toggleView: toggleView);
      //return RegisterTutor();
    }
  }
}
