import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:studently/model/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // tutors collection reference
  final CollectionReference tutorsCollection =
      FirebaseFirestore.instance.collection('tutors');
  // students collection reference
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  Students _studentsFromSnapshot(DocumentSnapshot snapshot) {
    return Students(
      uid: uid!,
      username: snapshot.get('username'),
    );
  }

  Tutors _tutorsFromSnapshot(DocumentSnapshot snapshot) {
    return Tutors(
      uid: uid!,
      username: snapshot.get('username'),
      name: snapshot.get('name'),
      about: snapshot.get('about'),
      photofilepath: snapshot.get('photofilepath'),
      languages: snapshot.get('languages'),
      skills: snapshot.get('skills'),
    );
  }

  Future updateTutorData(String username, String name, String about,
      String photofilepath, List languages, List skills) async {
    return await tutorsCollection.doc(uid).set({
      'username': username,
      'name': name,
      'about': about,
      'photofilepath': photofilepath,
      'languages': languages,
      'skills': skills,
      'uid': uid,
    });
  }

  Future updateTutorRegistration(String name, String about,
      String photofilepath, List languages, List skills) async {
    return await tutorsCollection.doc(uid).update({
      'name': name,
      'about': about,
      'photofilepath': photofilepath,
      'languages': languages,
      'skills': skills,
    }).catchError((error) => print("Failed to update user: $error"));
  }

  Future updateStudentData(String username) async {
    return await studentsCollection.doc(uid).set({
      'username': username,
      'uid': uid,
    });
  }

  Stream<Students> get studentsData {
    return studentsCollection.doc(uid).snapshots().map(_studentsFromSnapshot);
  }

  Stream<Tutors> get tutorsData {
    return tutorsCollection.doc(uid).snapshots().map(_tutorsFromSnapshot);
  }

  //get tutors stream
  Stream<QuerySnapshot> get tutors {
    return tutorsCollection.snapshots();
  }
}
