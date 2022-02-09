import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ParkShield/services/Requests/firestore_requesting.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // anon sign in
  Future<UserCredential> signInAnon() async {
    UserCredential result = await _auth.signInAnonymously();
    return result;
  }

  // email pass sign in
  Future<List<dynamic>> signInUser(
      {required String email, required String password}) async {
    if (email == '' && password == '') {
      return [-1, 'Some error'];
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return [1, 'No user found for that email'];
      } else if (e.code == 'wrong-password') {
        return [2, 'Wrong password provided for that user'];
      }
    }
    // Successful sign in
    return [0, ''];
  }

  // new register
  Future<List<dynamic>> registerUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return [2, 'The password provided is too weak'];
      } else if (e.code == 'email-already-in-use') {
        return [1, 'The account already exists for that email'];
      }
    }
    // Successful registration

    CollectionReference users = usersCollectionReference();

    users.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'email': email,
      'Total vehicles': 2,
    });

    users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('vehicles')
        .add({
      'vehicleID': 'vehicle1',
      'connectionStatus': 'Connected',
    });

    users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('vehicles')
        .add({
      'vehicleID': 'vehicle2',
      'connectionStatus': 'Not connected',
    });

    return [0, ''];
  }
}

bool checkLoggedIn() {
  User? user = FirebaseAuth.instance.currentUser;
  return (user != null);
}

Future<bool> signOut() async {
  await FirebaseAuth.instance.signOut();
  return !checkLoggedIn();
}
