import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:magic_sdk/magic_sdk.dart';

class DataStore {
  final magic = Magic.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // reference document
  final usersRef = FirebaseFirestore.instance.collection('users');
  final requestsRef = FirebaseFirestore.instance.collection('request');
  Future<void> addUser({
    required String name,
    required String email,
    required String token,
  }) async {
    try {
      await usersRef.add({
        'id': auth.currentUser?.uid,
        'name': name,
        'email': email,
        'createdAt': DateTime.now().toString(),
      });
    } on Exception catch (e) {
      Future.error(e);
    }
  }

  Future<void> addRequest({
    required String id,
    required String headline,
    required String instructions,
    required String time,
    required String startLocation,
    required String endLocation,
    required String price,
  }) async {
    try {
      await requestsRef.add({
        'id': id,
        'userId': auth.currentUser?.uid,
        'price': price,
        'headline': headline,
        'createdAt': DateTime.now().toString(),
        'time': time,
        'startLocation': startLocation,
        'endLocation': endLocation,
        'instructions': instructions
      });
    } on Exception catch (e) {
      Future.error(e);
    }
  }
}
