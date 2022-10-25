import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/widgets/home/comment_card.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:random_avatar/random_avatar.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.postId, required this.currentUser, required this.currentUserUid});

  final Map<String, dynamic>? currentUser;
  final String? currentUserUid;
  final String postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController commentEditingController = TextEditingController();
  late Database db;

  @override
  void initState() {
    db = Database();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await db.postComment(
        widget.postId,
        commentEditingController.text.trim(),
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
        backgroundColor: kAppBackgroundColor,
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
            return Center(
              child: ListView.separated(
                itemBuilder: (_, i) {
                  final delay = (i * 300);
                  return Container(
                    decoration: BoxDecoration(color: const Color(0xff242424), borderRadius: BorderRadius.circular(4)),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        FadeShimmer.round(
                          size: 40,
                          fadeTheme: FadeTheme.dark,
                          millisecondsDelay: delay,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeShimmer(
                              height: 8,
                              width: 150,
                              radius: 4,
                              millisecondsDelay: delay,
                              fadeTheme: FadeTheme.dark,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            FadeShimmer(
                              height: 8,
                              millisecondsDelay: delay,
                              width: 170,
                              radius: 4,
                              fadeTheme: FadeTheme.dark,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(
                  height: 16,
                ),
              ),
            );
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
                      hintText: 'Comment as ${widget.currentUser?['displayName'] ?? ''}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  widget.currentUserUid.toString(),
                  widget.currentUser?['displayName'],
                  widget.currentUser?['photoUrl'],
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Icon(
                      Icons.send,
                      color: Color.fromARGB(255, 172, 223, 185),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
