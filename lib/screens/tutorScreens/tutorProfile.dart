import 'package:flutter/material.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/tutorScreens/tutorUpdateProfile.dart';
import 'package:studently/services/auth.dart';
import 'package:studently/services/contacts.dart';
import 'package:studently/services/storage_service.dart';
import 'package:studently/shared/registerTextInput.dart';

class TutorProfile extends StatefulWidget {
  const TutorProfile({Key? key, required this.tutordata}) : super(key: key);
  final List<Tutors?> tutordata;

  @override
  State<TutorProfile> createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.tutordata[0]!.photofilepath.toString();
    String username = widget.tutordata[0]!.username.toString();
    String name = widget.tutordata[0]!.name.toString();

    final _formKey = GlobalKey<FormState>();
    final AuthService _auth = AuthService();
    final Storage storage = Storage();

    String path = "";
    getPath(username, path);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile",
            style: TextStyle(
                color: Color.fromARGB(182, 255, 254, 254),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 116, 187, 107),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                picProfile(username),
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TutorUpdateProfile(
                                tutordata: widget.tutordata,
                              )),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    "Update Profile",
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

Widget picProfile(String imageName) {
  final Storage storage = Storage();
  return FutureBuilder(
      future: storage.downloadURL(imageName),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Center(
              child: Stack(children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(snapshot.data!),
              radius: 50,
            ), // Positioned// CircleAvatar
          ] //<widget>[]
                  )); // Image.network // Container
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Container();
      });
}

Future<String> getPath(String username, String Imagepath) async {
  final Storage storage = Storage();
  Imagepath = await storage.downloadURL(username).toString();

  return Imagepath;
}
