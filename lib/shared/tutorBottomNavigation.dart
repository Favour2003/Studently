import 'package:flutter/material.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/tutorScreens/searchTutor.dart';

import '../screens/tutorScreens/tutorMessages.dart';
import '../screens/tutorScreens/tutorProfile.dart';

class TutorBottomNavigation extends StatefulWidget {
  const TutorBottomNavigation({Key? key, required this.tutordata})
      : super(key: key);
  final List<Tutors?> tutordata;

  @override
  State<TutorBottomNavigation> createState() => _TutorBottomNavigationState();
}

class _TutorBottomNavigationState extends State<TutorBottomNavigation> {
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    final screens = [
      Center(
          child: SearchTutor(
        tutordata: widget.tutordata,
      )),
      Center(
          child: TutorMessages(
        tutordata: widget.tutordata,
      )),
      Center(
          child: TutorProfile(
        tutordata: widget.tutordata,
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
              icon: Icon(Icons.person_sharp),
              label: "Profile",
            ),
          ]),
    );
  }
}
