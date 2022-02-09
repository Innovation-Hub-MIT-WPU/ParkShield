import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference userDocumentCollection({required String collection}) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(collection);
}

CollectionReference usersCollectionReference() {
  return FirebaseFirestore.instance.collection('users');
}

DocumentReference<Map<String, dynamic>> userDocumentReference() {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
}
