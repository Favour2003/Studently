import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studently/model/user.dart';
import 'package:studently/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:studently/services/contacts.dart';
import 'package:studently/services/database.dart';
import 'package:studently/shared/registerTextInput.dart';

class ProfileStudents extends StatefulWidget {
  const ProfileStudents({Key? key, required this.studentdata})
      : super(key: key);
  final List<Students?> studentdata;

  @override
  State<ProfileStudents> createState() => ProfileStudentsState();
}

class ProfileStudentsState extends State<ProfileStudents> {
  @override
  Widget build(BuildContext context) {
    String username = widget.studentdata[0]!.username.toString();
    final AuthService _auth = AuthService();

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile",
            style: TextStyle(
                color: Color.fromARGB(182, 74, 73, 73),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 155, 207, 148),
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
                      Text(username,
                          style: const TextStyle(
                              color: Color.fromARGB(182, 53, 52, 52),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Contacts()),
                    );
                  },
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
    );
  }
}

Widget picProfile() {
  return Center(
    child: Stack(children: const [
      CircleAvatar(
        radius: 75.0,
        backgroundImage: AssetImage('assets/images/NoProfile.png'),
        backgroundColor: Colors.grey,
      )
    ]),
  ); // Stack
}
