import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/pages/widgets/comment_card.dart';
import 'package:lrf/pages/widgets/comments/comment_tree.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

class CommentsPage extends StatefulWidget {
  final snap;

  const CommentsPage({super.key, required this.snap});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  bool reply = false;
  final TextEditingController _messageController = TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await Database().postComment(
        widget.snap['postId'],
        _messageController.text.trim(),
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        if (mounted) {
          showSnackBar(context, res);
        }
      }
      setState(() {
        _messageController.text = "";
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: false,
        backgroundColor: kAppBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(itemCount: snapshot.data!.docs.length, itemBuilder: (ctx, index) => CommentCard(snap: snapshot.data!.docs[index]));
          // CommentTree(
          //   snap: snapshot.data!.docs[index],
          // )
          // );
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
              CircleAvatar(
                backgroundColor: Colors.amber,
                backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      focusedBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                      hintText: 'Message..',
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              customButton(
                  text: 'Send',
                  onPressed: () => postComment(FirebaseAuth.instance.currentUser!.uid, FirebaseAuth.instance.currentUser!.displayName!,
                      FirebaseAuth.instance.currentUser!.photoURL!),
                  color: Colors.green.shade800)
            ],
          ),
        ),
      ),
    );
  }
}
