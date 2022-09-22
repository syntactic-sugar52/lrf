import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lrf/models/user_model.dart';
import 'package:lrf/services/database.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return '';
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credentials);
      UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          email: user.email,
          name: user.displayName!,
          photoURL: user.photoUrl!,
          createdAt: DateTime.now().toString(),
          phoneNumber: '',
          rating: '');
      // adding user in our database
      await _firestore.collection("users").doc(userCredential.user!.uid).set(userModel.toJson());
      // res = "success";
      // await Database().createUser(user.displayName!, user.email, userCredential.user!.uid, user.photoUrl!);
    } catch (e) {
      Future.error(e);
    }

    notifyListeners();
  }

  Future googleLogOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
