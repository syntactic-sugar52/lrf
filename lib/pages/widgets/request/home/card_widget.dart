import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore";

class Card2 extends StatelessWidget {
  final String documentId;
  const Card2({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get the collection
    CollectionReference reqRef = FirebaseFirestore.instance.collection('request');
    return FutureBuilder<DocumentSnapshot>(
      future: reqRef.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return ExpandableNotifier(
              child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ScrollOnExpand(
              child: Card(
                elevation: 4,
                color: const Color(0xff2D2C2C),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expandable(
                      collapsed: buildCollapsed1(),
                      expanded: buildExpanded1(),
                    ),
                    Expandable(
                      collapsed: buildCollapsed2(data['headline'], data['startLocation'], data['endLocation']),
                      expanded: buildExpanded2(),
                    ),
                    Expandable(
                      collapsed: buildCollapsed3(),
                      expanded: buildExpanded3(context),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white70,
                  radius: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "kd ang",
                  style: TextStyle(color: Colors.white),
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
                Text('4.5', style: TextStyle(color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    ]);
  }

  buildCollapsed2(String headline, String startLoc, String endLoc) {
    return buildImg(
      Colors.transparent,
      300,
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              headline,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Color(0xffF7EDDB), fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                color: Color(0xffFF9090),
              ),
              // todo: cut address dynamic
              Expanded(
                child: Text(
                  startLoc.substring(0, 50),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xffF7EDDB), fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                color: Color(0xff30E3CA),
              ),
              Expanded(
                child: Text(
                  endLoc.substring(0, 50),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xffF7EDDB), fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
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
                  color: Colors.blueGrey.shade200,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "60 Copper",
                  style: TextStyle(color: Colors.white),
                  // style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.clock,
                  color: Colors.blueGrey.shade200,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "1:10 pm",
                  style: TextStyle(color: Colors.blueGrey.shade100),
                  // style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
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

  buildExpanded3(BuildContext context) {
    // Color(0xffD1D1D1)
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              loremIpsum,
              style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 18, fontWeight: FontWeight.w500),
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
                foregroundColor: Colors.blueGrey,
                backgroundColor: const Color(0xff1B1B1B),
                textStyle: const TextStyle(color: kWhite),
                text: 'Slide to Accept',
                onConfirmation: () => confirmed(context),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    ).asGlass();
  }
}
