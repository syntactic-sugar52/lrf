import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

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

  Future addRequest(
      {required String id,
      required String headline,
      required String instructions,
      required String time,
      required String startLocation,
      required String endLocation,
      required String price,
      required String startLatitude,
      required String startLongitude,
      required String endLatitude,
      required String endLongitude}) async {
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
        'instructions': instructions,
        'startLatitude': startLatitude,
        'startLongitude': startLongitude,
        'endLatitude': endLatitude,
        'endLongitude': endLongitude
      });
    } on Exception catch (e) {
      Future.error(e);
    }
  }

  Position? _currentPosition;
  Position? get currentPostion => _currentPosition;
}
