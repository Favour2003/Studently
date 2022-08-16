import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  Future getData(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collection).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('tutors')
        .where('username', isGreaterThan: queryString)
        .get();
  }

  Future querySkillsData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('tutors')
        .where('skills', arrayContains: queryString)
        .get();
  }

  Future queryTutorMessages(String uid) async {
    var query = FirebaseFirestore.instance
        .collection("turors")
        .where("uid", isEqualTo: uid);
    return query.get().then((querySnapshot) => {
          querySnapshot.docs.forEach((element) {
            element.reference.collection("contacts").get();
          })
        });
  }
}
