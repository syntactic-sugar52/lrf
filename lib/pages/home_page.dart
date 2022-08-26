import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass/glass.dart';
import 'package:lrf/pages/request_accepted_page.dart';
import 'package:lrf/pages/widgets/home/swipe_card.dart';
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.lightGreenAccent,
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Card2(),
            Card2(),
            Card2(),
            Card2(),
            Card2(),
          ],
        ),
      ),
    );
  }
}

const loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore ";

class Card2 extends StatelessWidget {
  const Card2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildImg(Color color, double height, Widget child) {
      return SizedBox(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.all(8.0),
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
          padding: EdgeInsets.all(8),
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
                    style: TextStyle(color: Color(0xffCFFFDC)),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Color(0xffCFFFDC),
                    size: 14,
                  ),
                  Text('4.5', style: TextStyle(color: Color(0xffCFFFDC))),
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
          150,
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Paint something for my cats',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xffF7EDDB), fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Color(0xffFF9090),
                  ),
                  Text(
                    'start : Makati',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xffF7EDDB), fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Color(0xff30E3CA),
                  ),
                  Text(
                    'end   : Quezon City',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xffF7EDDB), fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ));
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
                children: const [
                  FaIcon(
                    FontAwesomeIcons.moneyBillTransfer,
                    color: Color(0xffCFFFDC),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "60 Copper",
                    style: TextStyle(color: Color(0xffCFFFDC)),
                    // style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.clock,
                    color: Color(0xffCFFFDC),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "1:10 pm",
                    style: TextStyle(color: Color(0xffCFFFDC)),
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
              // Expanded(child: buildImg(Colors.green, 100, Text('something'))),
              // Expanded(child: buildImg(Colors.orange, 100, Text('somethinf'))),
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

    buildExpanded3() {
      return Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // color: Colors.grey,
              child: Text(
                loremIpsum,
                style: TextStyle(color: Color(0xffF1F1F1), fontSize: 18, fontWeight: FontWeight.w500),
                softWrap: true,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InvertedButtonFb2(
                    text: 'ACCEPT REQUEST',
                    onPressed: () {
                      // todo: add animation page transition
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RequestAcceptedPage()));
                    }),
              ],
            ),
            // TextButton(
            //     onPressed: () {}, child: const Text('Accept', style: TextStyle(color: Color(0xffFFF38C), fontSize: 14, fontWeight: FontWeight.bold))),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ).asGlass();
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ScrollOnExpand(
        child: Card(
          color: Colors.blueGrey.shade600,
          // color: Color(0xff191919),
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
              Divider(
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
                          controller.expanded ? "COLLAPSE" : "EXPAND",
                          style: Theme.of(context).textTheme.button!.copyWith(color: Color(0xff6FEDD6)),
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

class InvertedButtonFb2 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  InvertedButtonFb2({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff4338CA);

    return OutlinedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          alignment: Alignment.center,
          side: MaterialStateProperty.all(const BorderSide(width: 1, color: Color(0xff00FFDD))),
          padding: MaterialStateProperty.all(const EdgeInsets.only(right: 75, left: 75, top: 12.5, bottom: 12.5)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)))),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Color(0xff00FFDD), fontSize: 16),
      ),
    );
  }
}
