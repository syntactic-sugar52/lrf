import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/reply_post_page.dart';
import 'package:lrf/pages/widgets/home/danger_animation.dart';
import 'package:lrf/services/database.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class Card2 extends StatefulWidget {
  const Card2({Key? key, required this.snap}) : super(key: key);

  final snap;

  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
  String currentUserId = '';
  bool dangerTapped = false;
  dynamic userDetails;

  @override
  void initState() {
    getUserData();

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
        // width: MediaQuery.of(context).size.width,
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
          // crossAxisAlignment: CrossAxisAlignment.,
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
      MediaQuery.of(context).size.height / 4,
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
            // const Text('text'),
            DangerAnimation(
              isAnimating: widget.snap['danger'].contains(currentUserId),
              smallLike: true,
              child: SizedBox(
                width: 50,
                height: 40,
                child: IconButton(
                  icon: widget.snap['danger'].contains(currentUserId)
                      ? const Icon(
                          Icons.warning,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.warning,
                          color: Colors.white70,
                        ),
                  onPressed: () => Database().flagPost(widget.snap['postId'].toString(), currentUserId, widget.snap['danger']),
                ),
              ),
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
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestAcceptedPage(postId: widget.snap['postId'].toString())));
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
            // instructions,
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
                // backgroundColor: const Color(0xff1B1B1B),
                textStyle: const TextStyle(color: kWhite),
                text: 'Slide to Reply',
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

  Future getUserData() async {
    userDetails = await Database().getUserDetails();

    setState(() {
      currentUserId = userDetails['id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ScrollOnExpand(
        scrollOnCollapse: true,
        scrollOnExpand: true,
        child: Card(
          elevation: 12,
          color: Colors.blueGrey.shade900,
          // color: Colors.black87,
          // color: Color(0xff393E46),
          // color: const Color(0xff2D2C2C),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('Last_Resort', style: TextStyle(color: Color(0xff42855B), fontWeight: FontWeight.w700)),
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
