import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreServices {
  static final CollectionReference _childsCollectionReference =
      FirebaseFirestore.instance.collection('childs');

  static Future<DocumentReference> addChild({
    required String name,
    required String instituteName,
    required String emergencyContact,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final value = await _childsCollectionReference.add({
      "institutionId": currentUser?.uid,
      "name": name,
      "instituteName": instituteName,
      "emergencyContact": emergencyContact,
      "homeLocation": null,
      "currentLocation": null,
    });
    return value;
  }
}
