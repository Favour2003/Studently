import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/studentScreens/chat_detailsStudente.dart';
import 'package:studently/shared/registerTextInput.dart';

class StudentMessages extends StatefulWidget {
  const StudentMessages({Key? key, required this.studentdata})
      : super(key: key);
  final List<Students?> studentdata;

  @override
  State<StudentMessages> createState() => _StudentMessagesState();
}

class _StudentMessagesState extends State<StudentMessages> {
  CollectionReference studentList =
      FirebaseFirestore.instance.collection("students");
  QuerySnapshot? snapshotData;
  bool hasMessages = false;
  var text = "check your messages";

  void getContacts() async {
    var query = studentList.where("uid", isEqualTo: widget.studentdata[0]!.uid);
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
                          text = "You have no messages";
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
                      builder: (context) => ChatDetailsStudente(
                            friendUserId: snapshotData!.docs[index]
                                    ['contactUid']
                                .toString(),
                            friendFullName: snapshotData!.docs[index]
                                    ['contactName']
                                .toString(),
                            friendProfilePhoto: snapshotData!.docs[index]
                                    ['photofilepath']
                                .toString(),
                            studentedata: widget.studentdata,
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
