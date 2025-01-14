import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/watch_data.dart';

class FireStoreServices {
  static final CollectionReference<Map<String, dynamic>>
      _childsCollectionReference =
      FirebaseFirestore.instance.collection('childs');
  static final CollectionReference<Map<String, dynamic>>
      _watchCollectionReference =
      FirebaseFirestore.instance.collection('watch');

  static final CollectionReference<Map<String, dynamic>>
      _institutesCollectionReference =
      FirebaseFirestore.instance.collection('institutes');

  static Future<DocumentReference> addChild({
    required String name,
    required String emergencyContact,
    required String parentUserName,
    required String watchId,
    required double latitude,
    required double longitude,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final instituteData =
        await _institutesCollectionReference.doc(currentUser?.uid).get();

    final value = await _childsCollectionReference.add({
      "institutionId": currentUser?.uid,
      "name": name,
      "instituteName": instituteData["name"],
      "parentUserName": parentUserName,
      "emergencyContact": emergencyContact,
      "homeLocation": GeoPoint(latitude, longitude),
      "currentLocation": null,
      "watchId": watchId,
    });
    await _institutesCollectionReference.doc(currentUser?.uid).update({
      "totalChildren": FieldValue.increment(1),
    });
    return value;
  }

  // Get Watch Data
  static Future<DocumentSnapshot> getWatchData(String watchId) async {
    final value = await _watchCollectionReference.doc(watchId).get();
    return value;
  }

  // get all childs of parent
  static Future<List<DocumentSnapshot>> getAllChilds(
      String parentUserName) async {
    final value = await _childsCollectionReference
        .where("parentUserName", isEqualTo: parentUserName)
        .get();
    return value.docs;
  }

  // Watch Data Stream
  static Stream<WatchData> watchData(String watchId) {
    return _watchCollectionReference.doc(watchId).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      return WatchData.fromMap(data);
    });
  }

  static Future updateWatchData(WatchData watchData) async {
    await _watchCollectionReference.doc(watchData.id).set(watchData.toMap());
  }

  static Future<DocumentSnapshot> getChildData(String childId) async {
    final value = await _childsCollectionReference.doc(childId).get();
    return value;
  }

  static Future<Map<String, dynamic>> getInstitutionData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final value =
        await _institutesCollectionReference.doc(currentUser?.uid).get();
    return value.data()!;
  }
}
