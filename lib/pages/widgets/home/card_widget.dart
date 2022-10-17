import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:lrf/main.dart';
import 'package:lrf/pages/widgets/home/danger_animation.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class Card2 extends StatefulWidget {
  const Card2({Key? key, required this.snap, required this.user, required this.subAdministrativeArea, required this.postalCode}) : super(key: key);

  final String postalCode;
  final Map<String, dynamic> snap;
  final String subAdministrativeArea;
  final User user;

  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
  String? currentUserId;
  String? currentUserName;
  String? currentUserPhotoUrl;
  bool dangerTapped = false;
  late Database db;
  String? postalCode;
  dynamic userDetails;

  @override
  void initState() {
    db = Database();
    currentUserId = sharedPreferences.getString('currentUserUid');
    currentUserName = sharedPreferences.getString('currentUserName');
    currentUserPhotoUrl = sharedPreferences.getString('currentUserPhotoUrl');
    postalCode = sharedPreferences.getString('postalCode');
    super.initState();
  }

  buildInnerCard(
    Color color,
    double height,
    Widget child,
  ) {
    return SizedBox(
        height: height,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
          child: child,
        )).asGlass();
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
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profImage'].toString()),
                  radius: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.snap['username'].toString(),
                  style: TextStyle(color: Colors.blueGrey.shade100),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  DateFormat.yMMMd().format(
                    widget.snap['datePublished'].toDate(),
                  ),
                  style: TextStyle(color: Colors.blueGrey.shade100),
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
      Colors.transparent,
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
                  color: Colors.white70,
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
                Icon(Icons.location_pin, color: Colors.green.shade600),
                Text(
                  widget.snap['subAdminArea'] ?? 'Postal Code: ${postalCode ?? widget.postalCode.toString()}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            widget.snap['userId'].toString() == widget.user.uid.toString()
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
                        child: const Text('Delete', style: TextStyle(color: Color(0xff42855B), fontWeight: FontWeight.w700))),
                  )
                : Text('Last Resrt', style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ]);
  }

  buildExpandedBody() {
    return Container();
  }

  buildExpandedDetails() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.snap['description'].toString(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              letterSpacing: .5,
            ),
            softWrap: true,
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              dense: true,
              leading: Icon(Icons.numbers, color: Colors.amber.shade800, size: 22),
              title: Text(
                widget.snap['contactNumber'].toString(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: .5,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Theme.of(context).primaryColor,
                      offset: const Offset(0.4, 0.2),
                    ),
                  ],
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: InkWell(
                onTap: () async {
                  try {
                    if (db.user.uid.toString() != widget.snap['userId'].toString()) {
                      String res = await db.updateContactedCollection(
                          userPostedId: currentUserId ?? db.user.uid.toString(),
                          postOwnerId: widget.snap['userId'].toString(),
                          isEmail: false,
                          isSms: true,
                          isSearchPage: false,
                          postId: widget.snap['postId'].toString());
                      if (res == 'success') {
                        setState(() {
                          db.sendSms("sms:${widget.snap['contactNumber'].toString()}", mounted, context);
                        });
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
                child: CircleAvatar(
                    radius: 14,
                    child: Icon(
                      Icons.contact_page_outlined,
                      size: 14,
                      color: Colors.blueGrey.shade100,
                    )),
              ),
            ),
          ),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              dense: true,
              leading: Icon(Icons.mail, color: Colors.blue.shade800, size: 22),
              title: Text(
                widget.snap['contactEmail'].toString(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  letterSpacing: .5,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Theme.of(context).primaryColor,
                      offset: const Offset(0.4, 0.2),
                    ),
                  ],
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
              ),
              trailing: InkWell(
                onTap: () async {
                  try {
                    if (db.user.uid.toString() != widget.snap['userId'].toString()) {
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
                child: CircleAvatar(
                    radius: 14,
                    child: Icon(
                      Icons.contact_page_outlined,
                      size: 14,
                      color: Colors.blueGrey.shade100,
                    )),
              ),
            ),
          ),
        ],
      ),
    ).asGlass();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: EdgeInsets.zero,
      child: ScrollOnExpand(
        scrollOnCollapse: true,
        scrollOnExpand: true,
        child: Card(
          elevation: 8,
          color: Colors.blueGrey.shade900,
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
                    elevation: 8,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            width: 15,
                          ),
                          Text(widget.snap['upVote'].length.toString(), style: const TextStyle(color: Colors.white70)),
                          DangerAnimation(
                            isAnimating: widget.snap['upVote'].contains(widget.user.uid),
                            smallLike: true,
                            child: SizedBox(
                              width: 50,
                              height: 40,
                              child: IconButton(
                                icon: widget.snap['upVote'].contains(widget.user.uid)
                                    ? Icon(
                                        Icons.arrow_circle_up_outlined,
                                        color: Colors.green.shade700,
                                      )
                                    : const Icon(
                                        Icons.arrow_circle_up_outlined,
                                        color: Colors.white70,
                                      ),
                                onPressed: () => db.upvotePost(widget.snap['postId'].toString(), db.user.uid, widget.snap['upVote']),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 1,
                            // width: 20,
                            color: Colors.black,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.snap['downVote'].length.toString(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          DangerAnimation(
                            isAnimating: widget.snap['downVote'].contains(widget.user.uid),
                            smallLike: true,
                            child: SizedBox(
                              width: 50,
                              height: 40,
                              child: IconButton(
                                icon: widget.snap['downVote'].contains(widget.user.uid)
                                    ? Icon(
                                        Icons.arrow_circle_down_rounded,
                                        color: Colors.pink.shade700,
                                      )
                                    : const Icon(
                                        Icons.arrow_circle_down_rounded,
                                        color: Colors.white70,
                                      ),
                                onPressed: () => db.downVotePost(widget.snap['postId'].toString(), db.user.uid, widget.snap['downVote']),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 50,
                            height: 40,
                            child: IconButton(
                                iconSize: 18,
                                onPressed: () async {
                                  Share.share(
                                    'Check this out on Last Resrt!, Download the app now. - ${widget.snap['title']}',
                                  );
                                },
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white70,
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
                            color: const Color(0xffCFFFDC),
                            shadows: [
                              Shadow(
                                blurRadius: 1.0,
                                color: Theme.of(context).primaryColor,
                                offset: const Offset(0.3, 0.3),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          controller.toggle();
                        },
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
  }
}
