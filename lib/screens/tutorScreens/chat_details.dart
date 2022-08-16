import 'dart:io';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studently/shared/loading.dart';

import '../../model/user.dart';

class ChatDetails extends StatefulWidget {
  ChatDetails({
    Key? key,
    required this.friendUserId,
    required this.friendFullName,
    required this.tutordata,
    required this.friendProfilePhoto,
  }) : super(key: key);
  String friendUserId;
  String friendFullName;
  String friendProfilePhoto;
  final List<Tutors?> tutordata;

  @override
  State<ChatDetails> createState() => _ChatDetailsState(
      friendUserId,
      friendFullName,
      friendProfilePhoto,
      tutordata[0]!.uid.toString(),
      tutordata[0]!.username.toString());
}

class _ChatDetailsState extends State<ChatDetails> {
  CollectionReference chats = FirebaseFirestore.instance.collection("chats");
  CollectionReference tutorList =
      FirebaseFirestore.instance.collection("tutors");
  CollectionReference studentList =
      FirebaseFirestore.instance.collection("students");
  String friendUid;
  String friendName;
  String friendProfilePhoto;
  String currentUserId;
  String currentUserName;
  bool loading = false;
  bool isContact = false;
  var chatDocId;
  var tutorDocId;
  var senderTutorDocId;
  var _textController = new TextEditingController();

  _ChatDetailsState(this.friendUid, this.friendName, this.friendProfilePhoto,
      this.currentUserId, this.currentUserName);

  @override
  void initState() {
    super.initState();
    checkUser();
    checkTutor();
  }

  void checkUser() async {
    await chats
        .where('users',
            isEqualTo: {friendUid: friendName, currentUserId: currentUserName})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });

              print(chatDocId);
            } else {
              await chats.add({
                'users': {
                  friendUid: friendName,
                  currentUserId: currentUserName
                },
              }).then((value) => {chatDocId = value.id});
            }
          },
        )
        .catchError((error) {});
  }

  void checkTutor() async {
    await tutorList.where('uid', isEqualTo: friendUid).limit(1).get().then(
      (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            tutorDocId = querySnapshot.docs.single.id;
          });

          print("Tutorrr: " + tutorDocId);
        }
      },
    ).catchError((error) {});

    await tutorList.where('uid', isEqualTo: currentUserId).limit(1).get().then(
      (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            senderTutorDocId = querySnapshot.docs.single.id;
          });

          print("meee: " + senderTutorDocId);
        }
      },
    ).catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    print(chatDocId.toString());
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'friendName': friendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
    checkUser();
    checkTutor();
    insertContact();
  }

  void insertContact() async {
    await tutorList
        .doc(tutorDocId)
        .collection('contacts')
        .where("contactUid", isEqualTo: currentUserId)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isEmpty) {
          await tutorList.doc(tutorDocId).collection('contacts').add({
            'createdOn': FieldValue.serverTimestamp(),
            'contactUid': currentUserId,
            'contactName': currentUserName,
            'photofilepath': widget.tutordata[0]!.photofilepath,
          });
        }
      },
    );

    await tutorList
        .doc(senderTutorDocId)
        .collection('contacts')
        .where("contactUid", isEqualTo: friendUid)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isEmpty) {
          await tutorList.doc(senderTutorDocId).collection('contacts').add({
            'createdOn': FieldValue.serverTimestamp(),
            'contactUid': friendUid,
            'contactName': friendName,
            'photofilepath': friendProfilePhoto,
          });
        }
      },
    );
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : StreamBuilder<QuerySnapshot>(
            stream: chats
                .doc(chatDocId)
                .collection("messages")
                .orderBy("createdOn", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Loading(),
                );
              }

              if (snapshot.hasData) {
                var data;
                return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    leading: const CupertinoNavigationBarBackButton(
                      color: Colors.white,
                    ),
                    padding: EdgeInsetsDirectional.zero,
                    backgroundColor: Colors.green,
                    middle: Text(
                      friendName,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  child: SafeArea(
                      child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          reverse: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            data = document.data()!;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: BubbleSpecialOne(
                                  text: data['msg'],
                                  color: isSender(data['uid']) == true
                                      ? Colors.green
                                      : Color(0xFFE8E8EE),
                                  tail: true,
                                  isSender: isSender(data['uid']),
                                  textStyle: TextStyle(
                                      color: isSender(data['uid']) == true
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 15),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: CupertinoTextField(
                              controller: _textController,
                            ),
                          )),
                          CupertinoButton(
                              child: const Icon(
                                Icons.send_sharp,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                sendMessage(_textController.text);
                              })
                        ],
                      )
                    ],
                  )),
                );
              } else {
                return Container();
              }
            },
          );
  }
}
