import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studently/model/user.dart';
import 'package:studently/services/auth.dart';
import 'package:studently/services/storage_service.dart';
import 'package:studently/shared/registerTextInput.dart';

class tutorProfile extends StatelessWidget {
  const tutorProfile({Key? key, required this.tutordata}) : super(key: key);
  final List<Tutors?> tutordata;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final AuthService _auth = AuthService();
    final Storage storage = Storage();
    XFile? _imagefile;

    String imageUrl = tutordata[0]!.photofilepath.toString();
    String username = tutordata[0]!.username.toString();
    String name = tutordata[0]!.name.toString();

    int currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text("Profile",
            style: TextStyle(
                color: Color.fromARGB(182, 74, 73, 73),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 249, 249, 249),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                picProfile(),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: Color.fromARGB(182, 14, 14, 14),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text(username,
                          style: const TextStyle(
                              color: Color.fromARGB(182, 53, 52, 52),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  label: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 15),
                  ),
                  style: registerElevatedButtonStyle.copyWith(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(100, 20, 100, 20)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone),
                  label: const Text(
                    "Contact Us",
                    style: TextStyle(fontSize: 15),
                  ),
                  style: registerElevatedButtonStyle.copyWith(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(100, 20, 100, 20)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _auth.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 15),
                  ),
                  style: registerElevatedButtonStyle.copyWith(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(100, 20, 100, 20)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => currentIndex = index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: "chat",
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
                backgroundColor: Colors.green),
          ]),
    );
  }
}

Widget picProfile() {
  return Center(
    child: Stack(children: [
      CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(
            "https://firebasestorage.googleapis.com/v0/b/studently-40927.appspot.com/o/profilePics%2Ffroz?alt=media&token=cc4c2d9d-94f7-4260-965d-eaf271a76c64"),
        radius: 50,
      ), // Positioned// CircleAvatar
    ] //<widget>[]
        ),
  ); // Stack
}
