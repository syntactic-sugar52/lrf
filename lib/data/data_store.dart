import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:lrf/models/user_model.dart';
import 'package:magic_sdk/magic_sdk.dart';

class DataStore extends ChangeNotifier {
  final magic = Magic.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addUser({
    required String name,
    required String email,
    required String token,
  }) async {
// reference document
    final docUsers = FirebaseFirestore.instance.collection('users').doc(token);
    final user = UserModel(
      id: docUsers.id,
      name: name,
      email: email,
      createdAt: DateTime.now().toString(),
    );
    final jsonMap = user.toMap();
    await docUsers.set(jsonMap);
  }

// Stream<List<UserModel>> readUsers() => docUsers.snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
// Future<UserModel?> readUser() async {
//   try {
//     //Get single document by id
//     final mgId = await magic.user.getIdToken();

//     final docUser = FirebaseFirestore.instance.collection('users').doc(mgId);
//     final snapshot = await docUser.get();

//     if (snapshot.exists) {
//       print(snapshot);
//       // return UserModel.fromJson(snapshot.data()!);
//     } else {
//       print('read User error');
//     }
//   } on Exception catch (e) {
//     print(e);
//   }
// }

  Future<List<UserModel>> readUser() async {
    final mgId = await magic.user.getIdToken();

    final docUser = _firestore.doc(mgId);
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection("users").get();
    final snapList = snapshot.docs.map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot)).toList();
    print(snapList[0].email);
    return snapList;
  }
}
