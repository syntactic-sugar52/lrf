import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/chat_page.dart';
import 'package:lrf/pages/inquiry_page.dart';
import 'package:lrf/pages/widgets/home/danger_animation.dart';
import 'package:lrf/services/database.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class Card2 extends StatefulWidget {
  const Card2({Key? key, required this.snap, required this.user}) : super(key: key);

  final snap;
  final User user;
  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
  // String currentUserId = '';
  bool dangerTapped = false;
  dynamic userDetails;

  // @override
  // bool get wantKeepAlive => true;
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
              children: const <Widget>[
                Icon(
                  Icons.star,
                  color: Color(0xffCFFFDC),
                  size: 14,
                ),
                // Text(rating, style: const TextStyle(color: Colors.white)),
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
          // Row(
          //   children: [
          //     Icon(
          //       Icons.location_pin,
          //       color: Color(0xff30E3CA),
          //     ),
          //     // todo: cut address dynamic
          //     Expanded(
          //       child: Text(
          //         getDistanceBetweenStartLocation.toString(),
          //         // startLoc.substring(0, 50),
          //         textAlign: TextAlign.start,
          //         style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 14, fontWeight: FontWeight.w600),
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Icon(
          //       Icons.location_pin,
          //       color: Color(0xffFF9090),
          //     ),
          //     Expanded(
          //       child: Text(
          //         getDistanceBetweenEndLocation.toString(),
          //         // endLoc.substring(0, 50),
          //         textAlign: TextAlign.start,
          //         style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 14, fontWeight: FontWeight.w600),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  buildCollapsed3() {
    return Container();
  }

  final user = FirebaseAuth.instance.currentUser!;
  buildExpanded1() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.moneyBillTransfer,
                  // color: Colors.white,
                  color: Colors.blueGrey.shade300,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.snap['price'].toString(),
                  // "$price Copper",
                  style: const TextStyle(color: Colors.white),
                  // style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text('Last_Resort', style: TextStyle(color: Color(0xff42855B), fontWeight: FontWeight.w700)),
            ),
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
          children: const <Widget>[
            // Expanded(
            //     child: buildImg(
            //   Colors.green,
            //   100,
            //   Text('something'),
            // )),
            // Expanded(
            //     child: buildImg(
            //   Colors.orange,
            //   100,
            //   Text('somethinf'),
            // )),
          ],
        ),
        // Row(
        //   children: <Widget>[
        //     Expanded(child: buildImg(Colors.blue, 100)),
        //     Expanded(child: buildImg(Colors.cyan, 100)),
        //   ],
        // ),
      ],
    );
  }

  void confirmed(BuildContext context) {
    if (mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RequestAcceptedPage(
                    postId: widget.snap['postId'].toString(),
                    user: widget.user,
                    postOwnerId: widget.snap['userId'].toString(),
                    postTitle: widget.snap['title'].toString(),
                  )));
    }
  }

  buildExpanded3() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.snap['description'].toString(),
            style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16, letterSpacing: .5, fontWeight: FontWeight.w500),
            softWrap: true,
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConfirmationSlider(
                height: 55,
                foregroundColor: const Color(0xff42855B),
                backgroundColor: kAppBackgroundColor,
                textStyle: const TextStyle(color: kWhite),
                text: 'Slide to Inquire',
                onConfirmation: () => confirmed(context),
              )
            ],
          ),
          const SizedBox(
            height: 20,
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
      // padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                                onPressed: () => Database().upvotePost(widget.snap['postId'].toString(), user.uid, widget.snap['upVote']),
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
                                onPressed: () => Database().downVotePost(widget.snap['postId'].toString(), user.uid, widget.snap['downVote']),
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
