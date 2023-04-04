import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String instituteName,
    required String instituteAddress,
  }) async {
    return await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference instituteCollection =
          firestore.collection('institutes');

      await instituteCollection.doc(value.user?.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'instituteName': instituteName,
        'instituteAddress': instituteAddress,
      });
      return value;
    });
  }
}
