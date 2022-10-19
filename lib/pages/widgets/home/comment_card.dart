import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final String dbUserUid;
  final String postId;

  const CommentCard({
    Key? key,
    required this.snap,
    required this.dbUserUid,
    required this.postId,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap.data()['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap.data()['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: ' --- ${widget.snap.data()['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap.data()['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  widget.dbUserUid.toString() == widget.snap.data()['uid'].toString()
                      ? InkWell(
                          onTap: () async {
                            try {
                              String res =
                                  await Database().deleteComment(postId: widget.postId, commentId: widget.snap.data()['commentId'].toString());
                              if (res == "success") {
                                if (mounted) {
                                  showSnackBar(context, 'Comment Deleted!');
                                }
                              } else {
                                if (mounted) {
                                  showSnackBar(context, 'Delete Unsuccessful, Try again.');
                                }
                              }
                            } catch (e) {
                              Future.error(e);
                              if (mounted) {
                                showSnackBar(context, 'Something went wrong, Try again.');
                              }
                            }
                          },
                          child: const Text('delete'))
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
