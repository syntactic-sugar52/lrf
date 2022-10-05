import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:glass/glass.dart';

import 'package:lrf/pages/widgets/home/danger_animation.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                Text(
                  widget.snap['subAdminArea'],
                  style: const TextStyle(color: Colors.white70),
                ),
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
                              if (mounted) {
                                showSnackBar(context, 'Deleted!');
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

  buildExpanded2() {
    return Container();
  }

  _textMe(String number) async {
    // final smsUri = Uri(
    //   scheme: 'sms',
    //   path: number,
    //   query: encodeQueryParameters(<String, String>{'body': 'Hey I am inquring about your post in Last Resrt'}),
    // );

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

  void _sendEmail(String email) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'LastResrt', 'body': ''},
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
            style: const TextStyle(
              color: Colors.white70,
              // color: Colors.blueGrey.shade100,
              fontSize: 16,
              letterSpacing: .5,
            ),
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
                Icon(Icons.numbers, color: Colors.amber.shade800),
                // Text(
                //   'Contact number: ',
                //   style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16, letterSpacing: .5, fontWeight: FontWeight.w500),
                // ),
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
                            showSnackBar(context, 'Contact Someone Else');
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          showSnackBar(context, e.toString());
                        }

                        Future.error(e);
                      }
                    },
                    child: Text(
                      widget.snap['contactNumber'].toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        // color: Colors.blueGrey.shade100,
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
                Icon(Icons.mail, color: Colors.blue.shade800),
                // Text(
                //   'Contact Email: ',
                //   style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16, letterSpacing: .5, fontWeight: FontWeight.w500),
                // ),
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
                          showSnackBar(context, 'Contact Someone Else');
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        showSnackBar(context, e.toString());
                      }

                      Future.error(e);
                    }
                  },
                  child: Text(
                    widget.snap['contactEmail'].toString(),
                    style: const TextStyle(
                      color: Colors.white70,
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
                                onPressed: () => Database().downVotePost(widget.snap['postId'].toString(), db.user.uid, widget.snap['downVote']),
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
                                onPressed: () {
                                  Share.share(
                                    'Check this out on Last Resrt!, Download the app now. - ${widget.snap['title']}',
                                  );
                                },
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white70,
                                )),
                          )
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
