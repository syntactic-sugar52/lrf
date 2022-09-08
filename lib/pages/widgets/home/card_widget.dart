import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:math' show atan2, cos, ln2, log, max, min, pi, sin, sqrt;

class Card2 extends StatefulWidget {
  Card2({Key? key, required this.documentId, this.currentUserPosition}) : super(key: key);

  final Position? currentUserPosition;

  final String documentId;

  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
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

  buildCollapsed1(String username, String rating) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white70,
                  radius: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  username,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.star,
                  color: Color(0xffCFFFDC),
                  size: 14,
                ),
                Text(rating, style: const TextStyle(color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    ]);
  }

  buildCollapsed2(String headline, String startLat, String startLong, String endLat, String endLong) {
    var getDistanceBetweenStartLocation = Geolocator.distanceBetween(
        widget.currentUserPosition!.latitude, widget.currentUserPosition!.longitude, double.parse(startLat), double.parse(startLong));
    var getDistanceBetweenEndLocation = Geolocator.distanceBetween(
        widget.currentUserPosition!.latitude, widget.currentUserPosition!.longitude, double.parse(endLat), double.parse(endLong));
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
                headline,
                // textAlign: TextAlign.start,
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

  buildExpanded1(String price, String time) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  "$price Copper",
                  style: const TextStyle(color: Colors.white),
                  // style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(
              width: 50,
              height: 40,
              child: Card(
                elevation: 4,
                color: Colors.blueGrey.shade800,
                child: const Center(
                    child: Icon(
                  Icons.flag_outlined,
                  color: Colors.white70,
                )),
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
          children: <Widget>[
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
    Navigator.pushNamed(context, '/requestAccepted');
  }

  buildExpanded3(BuildContext context, String instructions) {
    // Color(0xffD1D1D1)
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              instructions,
              style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16, letterSpacing: .5, fontWeight: FontWeight.w500),
              softWrap: true,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConfirmationSlider(
                height: 55,
                foregroundColor: Color(0xff42855B),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get the collection
    CollectionReference reqRef = FirebaseFirestore.instance.collection('request');
    return FutureBuilder<DocumentSnapshot>(
      future: reqRef.doc(widget.documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
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
                      collapsed: buildCollapsed1('kd', '3.7'),
                      expanded: buildExpanded1(data['price'], data['time']),
                    ),
                    Expandable(
                      collapsed:
                          buildCollapsed2(data['headline'], data['startLatitude'], data['startLongitude'], data['endLatitude'], data['endLongitude']),
                      expanded: buildExpanded2(),
                    ),
                    Expandable(
                      collapsed: buildCollapsed3(),
                      expanded: buildExpanded3(context, data['instructions']),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
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
                        const Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: const Text('Last_Resort', style: TextStyle(color: Color(0xff42855B), fontWeight: FontWeight.w700)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
        }
        // todo : add shimmer effect when loading
        return const Text('Loading');
      }),
    );
  }
}
