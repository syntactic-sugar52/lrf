import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lrf/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:uuid/uuid.dart';

class Database {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;

  // get user details
  Future getUserDetails({required String uid}) async {
    DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(uid).get();
    // returns map string dynamic
    return documentSnapshot.data();
    // return UserModel.fromSnap(documentSnapshot);
  }

  Future<Map> getUserDataFromFirestore(String uid) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map docData = doc.data() as Map;
    return docData;
  }

  Future<String> createUser(String displayName, String email, String id, String photoURL) async {
    String res = "Some error occurred";
    try {
      final docUser = usersRef.doc(id);
      final user = {'id': id, 'displayName': displayName, 'email': email, 'photoUrl': photoURL, 'createdAt': DateTime.now()};

      await docUser.set(user);
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateUserCollection({required String address, required String lat, required String lng, required String uid}) async {
    final docRequest = FirebaseFirestore.instance.collection('users').doc(uid);
    String res = "Some error occurred";
    try {
      final user = {
        'address': address,
        'lat': lat,
        'lng': lng,
      };
// create document and write data to firebase
      await docRequest.update(
        user,
      );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode ? '${userID}_$peerID' : '${peerID}_$userID';
  }

  Future<String> createPostRequest(
      {required String title,
      required String description,
      required String userId,
      required String contactNumber,
      required String contactEmail,
      required String username,
      required String country,
      required String currentAddress,
      required String subAdminArea,
      required String photoURL}) async {
    final postId = const Uuid().v4();
    final docRequest = FirebaseFirestore.instance.collection('posts').doc(postId);
    String res = "Some error occurred";
    try {
      final posts = {
        'postId': postId,
        'userId': userId,
        'username': username,
        'contactNumber': contactNumber,
        'contactEmail': contactEmail,
        'title': title,
        'country': country,
        'upVote': [],
        'downVote': [],
        'description': description,
        'datePublished': DateTime.now(),
        'profImage': photoURL,
        'subAdminArea': subAdminArea,
        'currentAddress': currentAddress
      };
// create document and write data to firebase
      await docRequest.set(posts);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePostRequest({required String postId}) async {
    final docRequest = FirebaseFirestore.instance.collection('posts').doc(postId);
    String res = "Some error occurred";
    try {
      await docRequest.delete();
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteComment({required String postId, required String commentId}) async {
    final docRequest = FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(commentId);
    String res = "Some error occurred";
    try {
      await docRequest.delete();
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateContactedCollection(
      {required String userPostedId,
      required String postOwnerId,
      required bool isEmail,
      required bool isSms,
      required String postId,
      required bool isSearchPage}) async {
    final id = const Uuid().v4();

    final docRequest = FirebaseFirestore.instance.collection('contacted').doc(id);
    String res = "Some error occurred";
    try {
      final posts = {
        'postId': postId,
        'isEmail': isEmail,
        'isSms': isSms,
        'users': [userPostedId, postOwnerId],
        'datePublished': DateTime.now(),
        'isSearchPage': isSearchPage
      };
// create document and write data to firebase
      await docRequest.set(posts, SetOptions(merge: true));
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateInquiryRequest({required bool isAccepted, required String postOwnerId, required String docId}) async {
    final docRequest = FirebaseFirestore.instance.collection('inquiry').doc(postOwnerId).collection('inquiryItems').doc(docId);
    String res = "Some error occurred";
    try {
      final posts = {
        'isAccepted': isAccepted,
      };
// create document and write data to firebase
      await docRequest.update(posts);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> upvotePost(String postId, String uid, List upvote) async {
    String res = "Some error occurred";
    try {
      if (upvote.contains(uid)) {
        // if the  list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'upVote': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'upVote': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> downVotePost(String postId, String uid, List downvote) async {
    String res = "Some error occurred";
    try {
      if (downvote.contains(uid)) {
        // if the  list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'downVote': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'downVote': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
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

  // Post comment
  Future<String> postMessage(
    String postId,
    String text,
    String idFrom,
    String idTo,
    String content,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it

        _firestore.collection('posts').doc(postId).collection('message').doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
          'content': content,
          'idFrom': idFrom,
          'idTo': idTo,
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString()
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

  void sendSms(String number, var mounted, BuildContext context) async {
    try {
      if (await canLaunchUrlString(number)) {
        await launchUrlString(number);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Some error occured');
      }
    }
  }

  void sendEmail(String email) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'LastResrt', 'body': ''},
    );
    launchUrl(emailLaunchUri);
  }
}
