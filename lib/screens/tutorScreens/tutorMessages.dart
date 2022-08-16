import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/tutorScreens/chat_details.dart';
import 'package:studently/services/dataController.dart';
import 'package:studently/shared/loading.dart';
import 'package:studently/shared/registerTextInput.dart';

class TutorMessages extends StatefulWidget {
  const TutorMessages({Key? key, required this.tutordata}) : super(key: key);
  final List<Tutors?> tutordata;

  @override
  State<TutorMessages> createState() => _TutorMessagesState();
}

class _TutorMessagesState extends State<TutorMessages> {
  CollectionReference tutorList =
      FirebaseFirestore.instance.collection("tutors");
  QuerySnapshot? snapshotData;
  bool hasMessages = false;
  var text = "check your messages";

  void getContacts() async {
    var query = tutorList.where("uid", isEqualTo: widget.tutordata[0]!.uid);
    await query.get().then((querySnapshot) => {
          querySnapshot.docs.forEach((element) {
            element.reference.collection("contacts").get().then((value) => {
                  setState(() {
                    snapshotData = value;
                  }),
                });
            return;
          })
        });
    snapshotData = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Messages",
              style: TextStyle(
                  color: Color.fromARGB(182, 255, 253, 253),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Color.fromARGB(255, 116, 187, 107),
        ),
        body: hasMessages
            ? messages()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 106, 106, 106),
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      getContacts();

                      if (snapshotData == null) {
                        print("nooooo");
                        setState(() {
                          text = "";
                          hasMessages = false;
                          snapshotData = null;
                        });
                        return;
                      }

                      if (snapshotData!.docs.isNotEmpty) {
                        print("yesssss");
                        setState(() {
                          hasMessages = true;
                        });
                      }
                    },
                    icon: const Icon(Icons.view_agenda),
                    label: const Text(
                      "See Messages",
                      style: TextStyle(fontSize: 15),
                    ),
                    style: registerElevatedButtonStyle.copyWith(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(100, 20, 100, 20)),
                    ),
                  ),
                ],
              ));
  }

  Widget messages() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatDetails(
                            friendUserId: snapshotData!.docs[index]
                                    ['contactUid']
                                .toString(),
                            friendFullName: snapshotData!.docs[index]
                                    ['contactName']
                                .toString(),
                            friendProfilePhoto: snapshotData!.docs[index]
                                    ['photofilepath']
                                .toString(),
                            tutordata: widget.tutordata,
                          )),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    snapshotData?.docs[index]['photofilepath'],
                  ),
                  radius: 25,
                ),
                title: Text(
                  snapshotData?.docs[index]['contactName'],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 84, 83, 83),
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
              ),
            ),
          ],
        );
      },
      itemCount: snapshotData?.docs.length,
    );
  }
}
