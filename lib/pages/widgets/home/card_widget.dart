import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/main.dart';
import 'package:lrf/pages/comment_screen.dart';
import 'package:lrf/pages/widgets/home/danger_animation.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

enum Options { flag, block, hide }

class Card2 extends StatefulWidget {
  const Card2({
    Key? key,
    required this.snap,
    required this.user,
  }) : super(key: key);

  final Map<String, dynamic> snap;
  final Map<String, dynamic>? user;

  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
  dynamic blUsers;
  int commentLength = 0;
  String? country;
  String? currentUserId;
  String? currentUserName;
  String? currentUserPhotoUrl;
  bool dangerTapped = false;
  late Database db;
  bool isHidden = false;
  String? postalCode;

  var _popupMenuItemIndex = 0;

  @override
  void initState() {
    // initialize database
    db = Database();
    //get locally saved data
    currentUserId = sharedPreferences.getString('currentUserUid');
    getBlockedCollection();
    getCommentLength();

    super.initState();
  }

  Future getCommentLength() async {
    if (mounted) {
      int totalCommentLength = await db.getCommentLength(widget.snap['postId'].toString());
      if (mounted) {
        setState(() {
          commentLength = totalCommentLength;
        });
      }
    }
  }

  buildInnerCard(
    Color color,
    double height,
    Widget child,
  ) {
    return Card(
      child: SizedBox(
          height: height,
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
            child: child,
          )).asGlass(),
    );
  }

  buildCollapsedHeader() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                randomAvatar(widget.snap['profImage'].toString(), height: 30),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.snap['username'].toString(),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  DateFormat.jm().format(
                    widget.snap['datePublished'].toDate(),
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  DateFormat.yMMMd().format(
                    widget.snap['datePublished'].toDate(),
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    ]);
  }

  Widget buildCollapsedBody() {
    return buildInnerCard(
      kWhite,
      MediaQuery.of(context).size.height / 6,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.snap['title'].toString(),
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCollapsedImgDetails() {
    return Container();
  }

  Widget buildExpandedHeader() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,

                      borderRadius: const BorderRadius.all(Radius.circular(10.0)), // Set rounded corner radius
                    ),
                    child: Text(
                      widget.snap['category'].toString(),
                      style: const TextStyle(color: Colors.white),
                    ))
              ],
            ),
            // if user id is the same as user id in database
            widget.snap['userId'].toString() == widget.user?['id']
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                        onTap: () async {
                          try {
                            String res = await db.deletePostRequest(postId: widget.snap['postId']);
                            if (res == 'success') {
                              if (mounted) {
                                showSnackBar(context, 'Post Deleted!');
                              }
                            } else {
                              if (mounted) {
                                showSnackBar(context, 'Delete Unsuccessful. Try Agin.');
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              showSnackBar(context, 'Something went wrong.');
                            }
                            Future.error(e);
                          }
                        },
                        child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700))),
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
                      _buildPopupMenuItem('Block User', Icons.block, Options.block.index),
                      _buildPopupMenuItem('Report Post', Icons.flag, Options.flag.index),
                      _buildPopupMenuItem('Hide Post', Icons.flag, Options.hide.index),
                    ],
                    child: const Center(child: Icon(Icons.more_vert_outlined)),
                  )
          ],
        ),
      ),
    ]);
  }

  SimpleDialogOption buildSimpleDialogOption(Function() onPressed, String text) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        children: [
          const Icon(Icons.flag),
          Expanded(
              child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          )),
        ],
      ),
    );
  }

  buildExpandedBody() {
    return Container();
  }

  buildExpandedDetails() {
    return Card(
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            widget.snap['imagePath'].toString().isNotEmpty
                ? Row(
                    children: <Widget>[
                      Expanded(
                          child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          height: 280,
                          child: Image.network(
                            widget.snap['imagePath'] != ''
                                ? widget.snap['imagePath'].toString()
                                : 'https://w7.pngwing.com/pngs/601/407/png-transparent-clouds-clouds-free-baiyun-t-clouds-clouds-clouds-cloud.png',
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      )),
                    ],
                  )
                : SizedBox.shrink(),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.snap['description'].toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: .2,
              ),
              softWrap: true,
            ),
            const SizedBox(
              height: 20,
            ),
            widget.snap['contactNumber'] != ''
                ? Card(
                    elevation: 3,
                    color: Colors.white54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.numbers,
                        size: 22,
                        color: Colors.grey.shade600,
                      ),
                      title: Text(
                        widget.snap['contactNumber'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          // letterSpacing: .5,
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () async {
                          try {
                            if (widget.user?['id'] != widget.snap['userId'].toString()) {
                              String res = await db.updateContactedCollection(
                                  userPostedId: currentUserId ?? db.user.uid.toString(),
                                  postOwnerId: widget.snap['userId'].toString(),
                                  isEmail: false,
                                  isSms: true,
                                  isSearchPage: false,
                                  postId: widget.snap['postId'].toString());
                              if (res == 'success') {
                                if (mounted) {
                                  setState(() {
                                    db.sendSms("sms:${widget.snap['contactNumber'].toString()}", mounted, context);
                                  });
                                }
                              } else {
                                if (mounted) {
                                  Clipboard.setData(ClipboardData(
                                    text: widget.snap['contactNumber'].toString(),
                                  )).then((_) {
                                    showSnackBar(context, "Copied to clipboard");
                                  });
                                }
                              }
                            } else {
                              if (mounted) {
                                showSnackBar(context, 'Contacting yourself is not allowed.');
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              showSnackBar(context, 'Something went wrong. Try Again.');
                            }
                            Future.error(e);
                          }
                        },
                        child: const PhysicalModel(
                          color: Colors.black,
                          elevation: 2.0,
                          shape: BoxShape.circle,
                          child: CircleAvatar(
                              radius: 14,
                              child: Icon(
                                Icons.arrow_forward,
                                size: 14,
                              )),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Card(
              color: Colors.white54,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                dense: true,
                leading: Icon(
                  Icons.mail,
                  size: 22,
                  color: Colors.grey.shade600,
                ),
                title: Text(
                  widget.snap['contactEmail'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                  ),
                  softWrap: true,
                ),
                trailing: InkWell(
                  onTap: () async {
                    try {
                      if (widget.user?['id'] != widget.snap['userId'].toString()) {
                        String res = await db.updateContactedCollection(
                            userPostedId: db.user.uid.toString(),
                            postOwnerId: widget.snap['userId'].toString(),
                            isEmail: true,
                            isSearchPage: false,
                            isSms: false,
                            postId: widget.snap['postId'].toString());
                        if (res == 'success') {
                          setState(() {
                            db.sendEmail(
                              widget.snap['contactEmail'].toString(),
                            );
                          });
                        } else {
                          if (mounted) {
                            Clipboard.setData(ClipboardData(
                              text: widget.snap['contactEmail'].toString(),
                            )).then((_) {
                              showSnackBar(context, "Copied to clipboard");
                            });
                          }
                        }
                      } else {
                        if (mounted) {
                          showSnackBar(context, 'Contacting yourself is not allowed.');
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        showSnackBar(context, e.toString());
                      }

                      Future.error(e);
                    }
                  },
                  child: const PhysicalModel(
                    color: mobileBackgroundColor,
                    elevation: 3.0,
                    shape: BoxShape.circle,
                    child: CircleAvatar(
                        radius: 14,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 14,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).asGlass();
  }

  Future<Map<String, dynamic>> getBlockedCollection() async {
    Map<String, dynamic> blockedUsers = {};
    try {
      var res = await db.getBlockedCollection(uid: widget.user?['id']);
      setState(() {
        blockedUsers = res;
      });
      for (var bu in blockedUsers.values) {
        blUsers = bu;
      }
    } catch (e) {
      Future.error(e);
    }

    return blockedUsers;
  }

  Widget buildBody() {
    Widget body = ExpandableNotifier(
        child: Padding(
      padding: EdgeInsets.zero,
      child: ScrollOnExpand(
        scrollOnCollapse: true,
        scrollOnExpand: true,
        child: Card(
          color: Colors.blueGrey.shade100,
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expandable(
                collapsed: buildCollapsedHeader(),
                expanded: buildExpandedHeader(),
              ),
              Expandable(
                collapsed: buildCollapsedBody(),
                expanded: buildExpandedBody(),
              ),
              Expandable(
                collapsed: buildCollapsedImgDetails(),
                expanded: buildExpandedDetails(),
              ),
              const Divider(
                height: 1,
              ),
              // Card Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                    elevation: 2,
                    color: kWhite,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                          ),
                          Text(
                            widget.snap['upVote'].length.toString(),
                          ),
                          DangerAnimation(
                            isAnimating: widget.snap['upVote'].contains(currentUserId ?? widget.user?['id']),
                            smallLike: true,
                            child: SizedBox(
                              width: 30,
                              height: 40,
                              child: IconButton(
                                icon: widget.snap['upVote'].contains(currentUserId ?? widget.user?['id'])
                                    ? Icon(
                                        Icons.arrow_circle_up_outlined,
                                        color: Colors.green.shade700,
                                      )
                                    : const Icon(
                                        Icons.arrow_circle_up_outlined,
                                      ),
                                onPressed: () => db.upvotePost(widget.snap['postId'].toString(), currentUserId ?? widget.user?['id'],
                                    widget.snap['upVote'], widget.snap['token'], widget.snap['title'], widget.snap['username']),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 1,
                            // width: 20,
                            color: Colors.black,
                          ),
                          Container(
                            width: 5,
                          ),
                          Text(
                            widget.snap['downVote'].length.toString(),
                          ),
                          DangerAnimation(
                            isAnimating: widget.snap['downVote'].contains(currentUserId ?? widget.user?['id']),
                            smallLike: true,
                            child: SizedBox(
                              width: 30,
                              height: 40,
                              child: IconButton(
                                icon: widget.snap['downVote'].contains(widget.user?['id'])
                                    ? Icon(
                                        Icons.arrow_circle_down_rounded,
                                        color: Colors.pink.shade700,
                                      )
                                    : const Icon(
                                        Icons.arrow_circle_down_rounded,
                                      ),
                                onPressed: () => db.downVotePost(widget.snap['postId'].toString(), widget.user?['id'], widget.snap['downVote'],
                                    widget.snap['token'], widget.snap['title'], widget.snap['username']),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 30,
                            height: 40,
                            child: IconButton(
                                iconSize: 18,
                                onPressed: () async {
                                  Share.share(
                                    'Check this out on BountyBay, Download the app now. - ${widget.snap['title']}',
                                  );
                                },
                                icon: const Icon(
                                  Icons.share,
                                )),
                          ),
                          const VerticalDivider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                          Text(
                            commentLength.toString(),
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                                iconSize: 18,
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentScreen(
                                                postId: widget.snap['postId'].toString(),
                                                currentUser: widget.user,
                                                currentUserUid: widget.user?['id'],
                                                token: widget.snap['token'].toString(),
                                                postOwnerId: widget.snap['userId'].toString(),
                                                postTitle: widget.snap['title'].toString(),
                                                postOwnerName: widget.snap['username'].toString(),
                                              )));
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.comment,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      var controller = ExpandableController.of(context, required: true)!;
                      return TextButton(
                        child: Text(
                          controller.expanded ? "CLOSE" : "OPEN",
                          style: Theme.of(context).textTheme.button!.copyWith(
                            shadows: [
                              Shadow(
                                blurRadius: 1.0,
                                color: Theme.of(context).primaryColor,
                                offset: const Offset(0.3, 0.3),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () => controller.toggle(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));

    if (widget.snap['hiddenFrom'].toString().contains(widget.user?['id']) || blUsers.toString().contains(widget.snap['userId'])) {
      body = const SizedBox.shrink();
    }

    return body;
  }

  _onMenuItemSelected(int value) async {
    setState(() {
      _popupMenuItemIndex = value;
    });
//todo: add condition
    if (value == Options.block.index) {
      await db.blockUsers(uid: widget.user?['id'], userBlockedid: widget.snap['userId']);
    } else if (value == Options.flag.index) {
      String res = await db
          .flagUser(
        widget.snap['postId'],
        widget.user?['id'],
        widget.snap['flag'],
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
                title: const Text('What\'s the problem?'),
                children: <Widget>[
                  buildSimpleDialogOption(
                    () => db
                        .reportPost(
                          postId: widget.snap['postId'],
                          reportReason: 'Hateful or abusive content',
                        )
                        .whenComplete(() => Navigator.pop(context)),
                    'Hateful or abusive content',
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  buildSimpleDialogOption(
                      () => db
                          .reportPost(reportReason: 'Violent or repulsive content', postId: widget.snap['postId'])
                          .whenComplete(() => Navigator.pop(context)),
                      'Violent or repulsive content'),
                  const Divider(
                    color: Colors.grey,
                  ),
                  buildSimpleDialogOption(
                      () => db.reportPost(reportReason: 'Sexual content', postId: widget.snap['postId']).whenComplete(() => Navigator.pop(context)),
                      'Sexual content'),
                  const Divider(
                    color: Colors.grey,
                  ),
                  buildSimpleDialogOption(
                    () => db.reportPost(reportReason: 'Spam or misleading', postId: widget.snap['postId']).whenComplete(() => Navigator.pop(context)),
                    'Spam or misleading',
                  ),
                ],
              );
            });
      });
    } else {
      await db.hidePost(widget.snap['postId'], widget.user?['id'], widget.snap['hiddenFrom']);
    }
  }

  PopupMenuItem _buildPopupMenuItem(String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }
}
