import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream userDocumentCollectionStream({required String document}) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(document)
      .snapshots();
}

CollectionReference usersCollectionReference() {
  return FirebaseFirestore.instance.collection('users');
}

DocumentReference<Map<String, dynamic>> userDocumentReference() {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
}
