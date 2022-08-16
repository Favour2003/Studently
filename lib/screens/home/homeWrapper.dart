import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studently/model/user.dart';
import 'package:studently/prove/textfieldTagProva.dart';
import 'package:studently/screens/authenticate/register/registerTutor.dart';
import 'package:studently/screens/studentScreens/profileStudent.dart';
import 'package:studently/screens/tutorScreens/tutorProfile.dart';
import 'package:studently/shared/studentBottomNavigation.dart';
import 'package:studently/shared/tutorBottomNavigation.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<Students?>(context);
    final tutor = Provider.of<Tutors?>(context);

    if (student?.username != "") {
      return StudentBottomNavigation(
        studentdata: [student],
      );
    } else {
      if (tutor?.about != "") {
        return TutorBottomNavigation(
          tutordata: [tutor],
        );
      } else {
        return RegisterTutor(
          tutordata: [tutor],
        );
      }
      //check if description is done then move to full register if not
    }
  }
}
