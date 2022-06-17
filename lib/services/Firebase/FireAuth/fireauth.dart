import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ParkShield/services/Firebase/FireStore/firestore.dart';
import 'package:ParkShield/services/Firebase/FireAuth/google_auth.dart'
    as google_auth;

final FirebaseAuth _auth = FirebaseAuth.instance;

// anon sign in
Future<UserCredential> signInAnon() async {
  UserCredential result = await _auth.signInAnonymously();
  return result;
}

// google sign in
Future<bool> signInWithGoogle() async {
  UserCredential result = await google_auth.signInWithGoogle();
  CollectionReference users = usersCollectionReference();

  if (!(await users.doc(result.user!.email).get()).exists) {
    users
        .doc(result.user!.email)
        .set({"email": result.user!.email, "Total Vehicles": 0});
  }
  return (result.user!.uid == _auth.currentUser!.uid);
}

// google sign out
Future<bool> signOutGoogle() async {
  await google_auth.signOutGoogle();
  return !checkLoggedIn();
}

// email pass sign in
Future<List<dynamic>> signInUser(
    {required String email, required String password}) async {
  if (email == '' && password == '') {
    return [-1, 'Some error'];
  }
  try {
    await _auth.signInWithEmailAndPassword(
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
    await _auth.createUserWithEmailAndPassword(
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

  users.doc(_auth.currentUser!.email).set({
    'Total vehicles': 0,
    'email': _auth.currentUser!.email,
  });

  // users.doc(_auth.currentUser!.email).collection('vehicles').add({
  //   'vehicleID': 'vehicle2',
  //   'connectionStatus': 'Not connected',
  // });

  // users.doc(_auth.currentUser!.uid).collection('vehicles').add({
  //   'vehicleID': 'vehicle1',
  //   'connectionStatus': 'Not connected',
  // });

  return [0, ''];
}

String getCurrentUserId() {
  if (checkLoggedIn()) {
    return _auth.currentUser!.email as String;
  }
  return "none";
}

User getCurrentUser() {
  return _auth.currentUser!;
}

bool checkLoggedIn() {
  User? user = _auth.currentUser;
  return (user != null);
}

Future<bool> signOut() async {
  await _auth.signOut();
  return !checkLoggedIn();
}
