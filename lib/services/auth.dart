import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studently/model/user.dart';
import 'package:studently/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  /// sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      print(email + " pass: " + password);
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print(user);

      return await _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email,
      String password,
      String username,
      String about,
      String type,
      String name,
      String photofilepath,
      List languages,
      List skills) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (type == 'tutor') {
        // create document for the tutors
        await DatabaseService(uid: user?.uid).updateTutorData(
            username, name, about, photofilepath, languages, skills);
      } else {
        // create document for the students
        await DatabaseService(uid: user?.uid).updateStudentData(username);
      }

      // await DatabaseServices(uid: user?.uid)
      //     .updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
