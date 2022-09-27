import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future createUser(String displayName, String email, String id, String photoURL) async {
    final docUser = usersRef.doc(id);
    final user = {'id': id, 'displayName': displayName, 'email': email, 'photoUrl': photoURL, 'createdAt': DateTime.now()};

    await docUser.set(user);
  }

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode ? '${userID}_$peerID' : '${peerID}_$userID';
  }

  // Future inquiryIsAccepted( String uid, String name, String profilePic, String postOwnerId,){
  //       final String id = getConversationID(postOwnerId, uid);
  //  final docRequest =   _firestore.collection('inquiry').doc(postOwnerId).collection('inquiryItems').doc();
  // //  docRequest.update();

  // }

  Future<String> createMessage({required String userId, required String peerID, required String inquiryId, required String postId}) async {
    final String convoId = getConversationID(userId, peerID);
    final docRequest = FirebaseFirestore.instance.collection('message').doc(convoId);
    String res = "Some error occurred";
    try {
      final message = {
        'inquiryId': inquiryId,
        'postId': postId,
        'users': [userId, peerID],
        'datePublished': DateTime.now(),
      };
// create document and write data to firebase
      await docRequest.set(message);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> startMessage({required String userId, required String peerID, required String content, required bool read}) async {
    final String convoId = getConversationID(userId, peerID);
    final docRequest = FirebaseFirestore.instance.collection('message').doc(convoId).collection(convoId).doc();
    String res = "Some error occurred";
    try {
      final message = {
        'lastMessage': {
          'content': content,
          'idFrom': userId,
          'idTo': peerID,
          'read': read,
          'datePublished': DateTime.now(),
        },
        'users': [userId, peerID],
      };
// create document and write data to firebase
      await docRequest.set(message);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> createPostRequest(
      {required String title,
      required String description,
      required String userId,
      required String price,
      required String username,
      required String photoURL}) async {
    final postId = const Uuid().v4();
    final docRequest = FirebaseFirestore.instance.collection('posts').doc(postId);
    String res = "Some error occurred";
    try {
      final posts = {
        'postId': postId,
        'userId': userId,
        'username': username,
        'title': title,
        'upVote': [],
        'downVote': [],
        'description': description,
        'datePublished': DateTime.now(),
        'price': price,
        'profImage': photoURL,
      };
// create document and write data to firebase
      await docRequest.set(posts);
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
        // if the likes list contains the user uid, we need to remove it
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
        // if the likes list contains the user uid, we need to remove it
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

  // Post reply
  Future<String> postInquiry(String postId, String text, String uid, String name, String profilePic, String postOwnerId, String title) async {
    String res = "Some error occurred";
    try {
      final inquiryId = const Uuid().v4();
      final String id = getConversationID(postOwnerId, uid);
      if (text.isNotEmpty) {
        _firestore.collection('inquiry').doc(postOwnerId).collection('inquiryItems').doc(inquiryId).set({
          'profilePic': profilePic,
          'sender': name,
          'senderUid': uid,
          'postOwnerId': postOwnerId,
          'postId': postId,
          'inquiryId': inquiryId,
          'text': text,
          'datePublished': DateTime.now(),
          'title': title,
          'isAccepted': false
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
  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
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
}
