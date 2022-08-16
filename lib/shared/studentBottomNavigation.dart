import 'package:flutter/material.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/studentScreens/profileStudent.dart';
import 'package:studently/screens/studentScreens/searchStudent.dart';
import 'package:studently/screens/studentScreens/studentMessages.dart';
import 'package:studently/screens/tutorScreens/SearchTutor.dart';

import '../screens/tutorScreens/tutorMessages.dart';
import '../screens/tutorScreens/tutorProfile.dart';

class StudentBottomNavigation extends StatefulWidget {
  const StudentBottomNavigation({Key? key, required this.studentdata})
      : super(key: key);
  final List<Students?> studentdata;

  @override
  State<StudentBottomNavigation> createState() =>
      _StudentBottomNavigationState();
}

class _StudentBottomNavigationState extends State<StudentBottomNavigation> {
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    final screens = [
      Center(
          child: SearchStudent(
        studentdata: widget.studentdata,
      )),
      Center(
          child: StudentMessages(
        studentdata: widget.studentdata,
      )),
      Center(
          child: ProfileStudents(
        studentdata: widget.studentdata,
      ))
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          iconSize: 25,
          selectedFontSize: 15,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() {
                currentIndex = index;
              }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "messages",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ]),
    );
  }
}
