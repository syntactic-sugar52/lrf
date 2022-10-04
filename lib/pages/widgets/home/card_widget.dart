import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:glass/glass.dart';

import 'package:lrf/pages/widgets/home/danger_animation.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Card2 extends StatefulWidget {
  const Card2({Key? key, required this.snap, required this.user, required this.subAdministrativeArea}) : super(key: key);

  final snap;
  final User user;

  final String subAdministrativeArea;
  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
  // String currentUserId = '';
  bool dangerTapped = false;

  late Database db;
  dynamic userDetails;

  @override
  void initState() {
    // TODO: implement initState
    db = Database();
    super.initState();
  }

  buildImg(
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

  buildCollapsed1() {
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
                  // username,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  DateFormat.yMMMd().format(
                    widget.snap['datePublished'].toDate(),
                  ),
                  style: const TextStyle(color: Colors.white),
                  // style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
      ),
    ]);
  }

  buildCollapsed2() {
    return buildImg(
      Colors.transparent,
      //todo: dynamic height
      MediaQuery.of(context).size.height / 6,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.snap['title'].toString(),
                style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildCollapsed3() {
    return Container();
  }

  buildExpanded1() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Icon(Icons.location_pin, color: Colors.green.shade600),
                Text(widget.subAdministrativeArea),
              ],
            ),
            widget.snap['userId'].toString() == widget.user.uid.toString()
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextButton(
                        onPressed: () async {
                          try {
                            String res = await db.deletePostRequest(postId: widget.snap['postId']);

                            if (res == 'success') {
                              print('delete success');
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
                : const SizedBox.shrink(),
          ],
        ),
      ),
    ]);
  }

  buildExpanded2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: const <Widget>[],
        ),
      ],
    );
  }

  _textMe(String number) async {
    // final separator = Platform.isIOS ? '&' : '?';
    //   _launchURL('sms:$number${separator}body=${Uri.encodeFull(content)}&subject=${Uri.encodeFull(subject)}');
    final smsUri = Uri(
      scheme: 'sms',
      path: number,
    );

    try {
      if (await canLaunchUrl(
        smsUri,
      )) {
        await launchUrl(smsUri);
      }
    } catch (e) {
      showSnackBar(context, 'Some error occured');
    }
  }

  void _sendEmail(String email) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Last Resrt Inquiry', 'body': ''},
    );
    launchUrl(emailLaunchUri);
  }

  buildExpanded3() {
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
            style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16, letterSpacing: .5, fontWeight: FontWeight.w500),
            softWrap: true,
          ),
          const SizedBox(
            height: 20,
          ),
          //todo: fix url launcher
          Card(
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Text('Contact number: '),
                TextButton(
                    onPressed: () async {
                      try {
                        if (db.user.uid.toString() != widget.snap['userId'].toString()) {
                          String res = await db.updateContactedCollection(
                              userPostedId: db.user.uid.toString(),
                              postOwnerId: widget.snap['userId'].toString(),
                              isEmail: false,
                              isSms: true,
                              postId: widget.snap['postId'].toString());
                          if (res == 'success') {
                            setState(() {
                              _textMe("sms:${widget.snap['contactNumber'].toString()}");
                            });
                          } else {
                            if (mounted) {
                              showSnackBar(context, res);
                            }
                          }
                        } else {
                          if (mounted) {
                            showSnackBar(context, 'Try a different card');
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          showSnackBar(context, e.toString());
                        }
                        print(e);
                        Future.error(e);
                      }
                    },
                    child: Text(
                      widget.snap['contactNumber'].toString(),
                      style: TextStyle(
                        color: Colors.green.shade400,
                        fontSize: 14,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    )),
              ],
            ),
          ),

          Card(
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Text('Contact Email: '),
                TextButton(
                  onPressed: () async {
                    try {
                      if (db.user.uid.toString() != widget.snap['userId'].toString()) {
                        String res = await db.updateContactedCollection(
                            userPostedId: db.user.uid.toString(),
                            postOwnerId: widget.snap['userId'].toString(),
                            isEmail: true,
                            isSms: false,
                            postId: widget.snap['postId'].toString());
                        if (res == 'success') {
                          setState(() {
                            _sendEmail(
                              widget.snap['contactEmail'].toString(),
                            );
                          });
                        } else {
                          if (mounted) {
                            showSnackBar(context, res);
                          }
                        }
                      } else {
                        if (mounted) {
                          showSnackBar(context, 'Try a different card');
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        showSnackBar(context, e.toString());
                      }
                      print(e);
                      Future.error(e);
                    }
                  },
                  child: Text(
                    widget.snap['contactEmail'].toString(),
                    style: TextStyle(
                      color: Colors.green.shade400,
                      fontSize: 14,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).asGlass();
  }

  @override
  Widget build(BuildContext context) {
    // super.build;
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
                collapsed: buildCollapsed1(),
                expanded: buildExpanded1(),
              ),
              Expandable(
                collapsed: buildCollapsed2(),
                expanded: buildExpanded2(),
              ),
              Expandable(
                collapsed: buildCollapsed3(),
                expanded: buildExpanded3(),
              ),
              const Divider(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                    elevation: 2,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            width: 15,
                          ),
                          Text(widget.snap['upVote'].length.toString()),
                          DangerAnimation(
                            isAnimating: widget.snap['upVote'].contains(widget.user.uid),
                            smallLike: true,
                            child: SizedBox(
                              width: 50,
                              height: 40,
                              child: IconButton(
                                icon: widget.snap['upVote'].contains(widget.user.uid)
                                    ? const Icon(
                                        Icons.arrow_circle_up_outlined,
                                        color: Colors.green,
                                      )
                                    : const Icon(
                                        Icons.arrow_circle_up_outlined,
                                        color: Colors.white70,
                                      ),
                                onPressed: () => Database().upvotePost(widget.snap['postId'].toString(), db.user.uid, widget.snap['upVote']),
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
                          Text(widget.snap['downVote'].length.toString()),
                          DangerAnimation(
                            isAnimating: widget.snap['downVote'].contains(widget.user.uid),
                            smallLike: true,
                            child: SizedBox(
                              width: 50,
                              height: 40,
                              child: IconButton(
                                icon: widget.snap['downVote'].contains(widget.user.uid)
                                    ? const Icon(
                                        Icons.arrow_circle_down_rounded,
                                        color: Colors.pink,
                                      )
                                    : const Icon(
                                        Icons.arrow_circle_down_rounded,
                                        color: Colors.white70,
                                      ),
                                onPressed: () => Database().downVotePost(widget.snap['postId'].toString(), db.user.uid, widget.snap['downVote']),
                              ),
                            ),
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
