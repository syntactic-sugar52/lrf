import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lrf/pages/widgets/home/danger_animation.dart';

import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../../constants/widgets.dart';

enum Options { flag, block, hide, delete }

class CommentCard extends StatefulWidget {
  const CommentCard(
      {Key? key,
      required this.snap,
      required this.dbUserUid,
      required this.postId,
      required this.currentUser,
      required this.postOwnerId,
      required this.blockedUsers})
      : super(key: key);

  final dynamic blockedUsers;
  final Map<String, dynamic>? currentUser;
  final String dbUserUid;
  final String postId;
  final String postOwnerId;
  final dynamic snap;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  var _popupMenuItemIndex = 0;

  Widget buildBody() {
    final db = Provider.of<Database>(context, listen: false);
    Widget body = Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      randomAvatar(widget.snap.data()['profilePic'], height: 40),
                      const SizedBox(
                        width: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: widget.snap.data()['name'], style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${widget.snap.data()['text']}', style: const TextStyle(color: Colors.black)),
                  const Divider(),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        widget.snap.data()['upVote'].length.toString(),
                      ),
                      DangerAnimation(
                        isAnimating: widget.snap.data()['upVote'].contains(widget.dbUserUid.toString()),
                        smallLike: true,
                        child: SizedBox(
                          width: 30,
                          height: 40,
                          child: IconButton(
                              icon: widget.snap.data()['upVote'].contains(widget.dbUserUid.toString())
                                  ? Icon(
                                      Icons.arrow_circle_up_outlined,
                                      color: Colors.green.shade700,
                                    )
                                  : const Icon(
                                      Icons.arrow_circle_up_outlined,
                                    ),
                              onPressed: () async {
                                await db.upvoteComment(
                                    widget.postId,
                                    widget.dbUserUid.toString(),
                                    widget.snap.data()['upVote'],
                                    widget.currentUser?['token'],
                                    widget.snap.data()['text'],
                                    widget.snap.data()['name'],
                                    widget.snap.data()['commentId']);
                              }),
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                        width: 20,
                        color: Colors.black,
                      ),
                      Text(
                        widget.snap.data()['downVote'].length.toString(),
                      ),
                      DangerAnimation(
                        isAnimating: widget.snap.data()['downVote'].contains(widget.dbUserUid.toString()),
                        smallLike: true,
                        child: SizedBox(
                          width: 30,
                          height: 40,
                          child: IconButton(
                              icon: widget.snap.data()['downVote'].contains(widget.dbUserUid.toString())
                                  ? Icon(
                                      Icons.arrow_circle_down_rounded,
                                      color: Colors.pink.shade700,
                                    )
                                  : const Icon(
                                      Icons.arrow_circle_down_rounded,
                                    ),
                              onPressed: () {
                                db.downVoteComment(
                                    widget.postId,
                                    widget.dbUserUid.toString(),
                                    widget.snap.data()['downVote'],
                                    widget.currentUser?['token'],
                                    widget.snap.data()['text'],
                                    widget.snap.data()['name'],
                                    widget.snap.data()['commentId']);
                              }),
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                        width: 20,
                        color: Colors.black,
                      ),
                      widget.dbUserUid.toString() != widget.snap.data()['uid'].toString()
                          ? PopupMenuButton(
                              onSelected: (value) {
                                _onMenuItemSelected(value as int);
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                              itemBuilder: (ctx) => [
                                //lib/ constants/widgets
                                buildPopupMenuItem('Block User', Icons.block, Options.block.index),
                                buildPopupMenuItem('Report Comment', Icons.report, Options.flag.index),
                                buildPopupMenuItem('Hide Comment', Icons.hide_image, Options.hide.index),
                              ],
                              child: const Center(
                                  child: Icon(
                                Icons.more_vert_outlined,
                                size: 16,
                              )),
                            )
                          : PopupMenuButton(
                              onSelected: (value) {
                                _onMenuItemSelected(value as int);
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                              itemBuilder: (ctx) => [
                                //lib/ constants/widgets
                                buildPopupMenuItem('Delete', Icons.block, Options.delete.index),
                              ],
                              child: const Center(
                                  child: Icon(
                                Icons.more_vert_outlined,
                                size: 16,
                              )),
                            ),
                      const VerticalDivider(
                        thickness: 1,
                        width: 20,
                        color: Colors.black,
                      ),
                      Text(
                        DateFormat.yMMMd().format(
                          widget.snap.data()['datePublished'].toDate(),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                        width: 20,
                        color: Colors.black,
                      ),
                      Text(
                        DateFormat.jm().format(
                          widget.snap.data()['datePublished'].toDate(),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    if (widget.snap['hiddenFrom'].toString().contains(
              widget.currentUser?['id'],
            ) ||
        widget.blockedUsers.toString().contains(
              widget.snap.data()['uid'],
            )) {
      body = const SizedBox.shrink();
    }
    return body;
  }

  _onMenuItemSelected(int value) async {
    final db = Provider.of<Database>(context, listen: false);
    setState(() {
      _popupMenuItemIndex = value;
    });

    if (value == Options.block.index) {
      try {
        await db
            .blockUsers(
          uid: widget.currentUser?['id'],
          userBlockedid: widget.snap.data()['uid'],
        )
            .whenComplete(() {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  title: const Text('This user is blocked. Please refresh the page.'),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              });
        });
      } catch (e) {
        Future.error(e);
      }
    } else if (value == Options.flag.index) {
      try {
        await db
            .flagComment(widget.postId, widget.currentUser?['id'], widget.snap['flag'], widget.snap.data()['commentId'].toString())
            .whenComplete(() {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  title: const Text('What\'s the problem?'),
                  children: <Widget>[
                    buildSimpleDialogOption(
                      () => db
                          .reportComment(
                              postId: widget.postId,
                              reportReason: 'Hateful or abusive content',
                              commentId: widget.snap.data()['commentId'].toString())
                          .whenComplete(() => Navigator.pop(context))
                          .whenComplete(() => buildDialog(context)),
                      'Hateful or abusive content',
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    buildSimpleDialogOption(
                        () => db
                            .reportComment(
                                reportReason: 'Violent or repulsive content',
                                postId: widget.postId,
                                commentId: widget.snap.data()['commentId'].toString())
                            .whenComplete(() => Navigator.pop(context))
                            .whenComplete(() => buildDialog(context)),
                        'Violent or repulsive content'),
                    const Divider(
                      color: Colors.grey,
                    ),
                    buildSimpleDialogOption(
                        () => db
                            .reportComment(
                                reportReason: 'Sexual content', postId: widget.postId, commentId: widget.snap.data()['commentId'].toString())
                            .whenComplete(() => Navigator.pop(context))
                            .whenComplete(() => buildDialog(context)),
                        'Sexual content'),
                    const Divider(
                      color: Colors.grey,
                    ),
                    buildSimpleDialogOption(
                      () => db
                          .reportComment(
                              reportReason: 'Spam or misleading', postId: widget.postId, commentId: widget.snap.data()['commentId'].toString())
                          .whenComplete(() => Navigator.pop(context))
                          .whenComplete(() => buildDialog(context)),
                      'Spam or misleading',
                    ),
                  ],
                );
              });
        });
      } catch (e) {
        Future.error(e);
      }
    } else if (value == Options.delete.index) {
      try {
        String res = await Database().deleteComment(postId: widget.postId, commentId: widget.snap.data()['commentId'].toString());
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
    } else {
      try {
        await db.hideComment(widget.postId, widget.currentUser?['id'], widget.snap['hiddenFrom'], widget.snap.data()['commentId'].toString());
      } catch (e) {
        Future.error(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }
}
