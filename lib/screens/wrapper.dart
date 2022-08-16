import 'package:flutter/material.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/authenticate/authenticate.dart';
import 'package:studently/screens/home/homeWrapper.dart';
import 'package:studently/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  // This widget is the root of your application.

  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    // AuthService _auth = AuthService();

    // _auth.signOut();

    //return home or authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return MultiProvider(
        providers: [
          StreamProvider<Students>.value(
              value: DatabaseService(uid: user.uid).studentsData,
              initialData: Students(uid: "", username: "")),
          StreamProvider<Tutors>.value(
              value: DatabaseService(uid: user.uid).tutorsData,
              initialData: Tutors(
                  uid: "",
                  username: "",
                  name: "",
                  about: "",
                  photofilepath: "",
                  languages: [],
                  skills: []))
        ],
        child: const HomeWrapper(),
      );
      //return const ProfileStudent();
    }
  }
}
