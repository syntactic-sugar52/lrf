import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'package:lrf/models/post_model.dart';
import 'package:lrf/models/user_model.dart';
import 'package:lrf/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

class Database {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
    // returns map string dynamic
    return documentSnapshot.data();
    // return UserModel.fromSnap(documentSnapshot);
  }

  Future createUser(
    String displayName,
    String email,
    String id,
    String photoURL,
  ) async {
    final docUser = usersRef.doc(id);
    final user = {'id': id, 'displayName': displayName, 'email': email, 'photoUrl': photoURL, 'createdAt': DateTime.now()};

    await docUser.set(user);
  }

  Future createPostRequest(
      {required String title, required String description, required String userId, required String price, required String username}) async {
    final docRequest = FirebaseFirestore.instance.collection('request').doc();
    final request = {
      'id': docRequest.id,
      'userId': userId,
      'username': username,
      'title': title,
      'description': description,
      'createdAt': DateTime.now(),
      'price': price,
    };
// create document and write data to firebase
    await docRequest.set(request);
  }

  Future<String> uploadPost(String description, String uid, String username, String profImage, String title, String price) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      // String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          title: title,
          danger: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: '',
          profImage: profImage,
          price: price);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> flagPost(String postId, String uid, List flag) async {
    String res = "Some error occurred";
    try {
      if (flag.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'danger': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'danger': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post reply
  Future<String> postReply(String postId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String replyId = const Uuid().v1();
        _firestore.collection('posts').doc(postId).collection('replies').doc(replyId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'replyId': replyId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
