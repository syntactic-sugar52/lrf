import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:lrf/main.dart';
import 'package:lrf/pages/widgets/home/comment_card.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:random_avatar/random_avatar.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen(
      {super.key,
      required this.postId,
      required this.currentUser,
      required this.currentUserUid,
      required this.token,
      required this.postOwnerName,
      required this.postOwnerId,
      required this.postTitle});

  final Map<String, dynamic>? currentUser;
  final String? currentUserUid;
  final String postId;
  final String token;
  final String postOwnerId;
  final String postTitle;
  final String postOwnerName;
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController commentEditingController = TextEditingController();
  late Database db;
  String? username;
  String? userId;
  String? currentUserPhotoUrl;
  @override
  void initState() {
    db = Database();
    username = sharedPreferences.getString('currentUserName');
    userId = sharedPreferences.getString('currentUserUid');
    currentUserPhotoUrl = sharedPreferences.getString('currentUserPhotoUrl');
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void postComment(String uid, String name, String profilePic, String token) async {
    try {
      String res = await db.postComment(
        widget.postId,
        commentEditingController.text.trim(),
        uid,
        widget.currentUser?['username'],
        profilePic,
      );

      if (widget.postOwnerId != widget.currentUser?['id']) {
        await db.sendPushNotification(
          token,
          'Someone commented on ${widget.postTitle}!',
          'Hey, ${widget.postOwnerName}',
        );
      }
      if (res != 'success') {
        if (mounted) {
          showSnackBar(context, res);
        }
      }
      // clear comment controller
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }

          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
              dbUserUid: widget.currentUserUid.toString(),
              postId: widget.postId,
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              randomAvatar(widget.currentUser?['photoUrl'], width: 39),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${widget.currentUser?['username']}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    postComment(widget.currentUserUid.toString(), widget.currentUser?['username'], widget.currentUser?['photoUrl'], widget.token),
                child:
                    Container(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8), child: Icon(Icons.send, color: Colors.blue.shade900)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
