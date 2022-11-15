import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

import 'package:lrf/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class Database {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final postsRef = FirebaseFirestore.instance.collection('posts');
  final firebase_storage.FirebaseStorage storageRef = firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;

  // get user details
  Future getUserDetails({required String uid}) async {
    DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(uid).get();
    // returns map string dynamic
    return documentSnapshot.data();
  }

  Future getCommentLength(postID) async {
    var lengthQuery = _firestore.collection('posts/$postID/comments');
    var querySnapshot = await lengthQuery.get();
    var totalEquals = querySnapshot.docs.length;
    return totalEquals;
  }

  Future<String> createUser(
    String phoneNumber,
    String id,
    String photoURL,
    String username,
    String udid,
  ) async {
    String res = "Some error occurred";
    try {
      final docUser = usersRef.doc(id);
      final user = {
        'id': id,
        'phoneNumber': phoneNumber,
        'photoUrl': photoURL,
        'createdAt': DateTime.now(),
        'username': username,
        'udid': udid,
        'token': ''
      };

      await docUser.set(user, SetOptions(merge: true));
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
      required String imagePath,
      required String postId,
      required String token,
      required String category,
      required String photoURL}) async {
    final docRequest = FirebaseFirestore.instance.collection('posts').doc(postId);
    String res = "Some error occurred";
    try {
      final posts = {
        'postId': postId,
        'userId': userId,
        'username': username,
        'contactNumber': contactNumber,
        'contactEmail': contactEmail,
        'token': token,
        'imagePath': imagePath,
        'title': title,
        'category': category,
        'upVote': [],
        'downVote': [],
        'description': description,
        'datePublished': DateTime.now(),
        'profImage': photoURL,
      };
// create document and write data to firebase
      await docRequest.set(
        posts,
      );
      res = "success";
    } on FirebaseException catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePostRequest({required String postId}) async {
    // when a post is deleted, delete entire subcollection too
    final docRequest = FirebaseFirestore.instance.collection('posts').doc(postId);
    var collection = FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments');
    var snapshots = await collection.get();
    String res = "Some error occurred";
    try {
      await docRequest.delete();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
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

  Future<String> upvotePost(String postId, String uid, List upvote, String token, String title, String username) async {
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

        await sendPushNotification(token, 'You got an upvote on $title', 'Hey, $username');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> sendPushNotification(
    String token,
    String body,
    String title,
  ) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAyCh7AuA:APA91bEOckVMMrOigdIcf9VO3MxiRYF7fEH4zvypk6wi_cCI9T-TtKhmJlrcpWxS9pXDV2xLJEy2QCA4x147ANj62cNl7OF1et8-nl17EqX2x6-nRYadcfbVQUFajXb1Cl4dpwYJnzQU'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'status': 'done', 'body': body, 'title': title},
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
            },
            'to': token
          },
        ),
      );
    } catch (e) {
      Future.error(e);
    }
  }

  Future<String> downVotePost(String postId, String uid, List downvote, String token, String title, String username) async {
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

        await sendPushNotification(token, 'You got a downvote on $title', 'Hey, $username');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v4();
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
  Future<String> postMessage(String postId, String text, String idFrom, String idTo, String content, String token) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it

        _firestore.collection('posts').doc(postId).collection('message').doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
          'content': content,
          'idFrom': idFrom,
          'idTo': idTo,
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'token': token
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
      queryParameters: {'subject': 'BountyBay', 'body': ''},
    );
    launchUrl(emailLaunchUri);
  }
}
