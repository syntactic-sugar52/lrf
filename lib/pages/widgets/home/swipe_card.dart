// ignore_for_file: unnecessary_const

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

const List<String> urls = [
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSn-5tIvIK60Phd47InOpHm-x63U5ARjxZ_3Q&usqp=CAU",
  "https://png.pngtree.com/thumb_back/fh260/background/20200821/pngtree-dark-green-solid-color-wallpaper-image_396566.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPwX1dwnvmkCpxPQJBSB9YhUDldYVCavdUQQ&usqp=CAU",
  "https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8d29tYW4lMjBwb3J0cmFpdHxlbnwwfHwwfHw%3D&w=1000&q=80",
  "https://images.unsplash.com/photo-1561442748-c50715dc32f6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXw5MjU4MjM3fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
  "https://images.unsplash.com/photo-1589156191108-c762ff4b96ab?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8YmxhY2slMjB3b21hbiUyMHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"
];

List<Widget> cards = urls.map((url) => SwipeImage(url: url)).toList();

// -=-=--=- (Small Cards) =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// List<Widget> cards = [
//   CardFb1(
//       text: "Explore",
//       imageUrl:
//           "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/illustrations%2Fundraw_Working_late_re_0c3y%201.png?alt=media&token=7b880917-2390-4043-88e5-5d58a9d70555",
//       subtitle: "+30 books",
//       onPressed: () {}),
//   CardFb1(
//       text: "Implore",
//       imageUrl:
//           "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/illustrations%2Fundraw_Working_late_re_0c3y%201.png?alt=media&token=7b880917-2390-4043-88e5-5d58a9d70555",
//       subtitle: "+30 books",
//       onPressed: () {}),
//   CardFb1(
//       text: "Deplore",
//       imageUrl:
//           "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/illustrations%2Fundraw_Working_late_re_0c3y%201.png?alt=media&token=7b880917-2390-4043-88e5-5d58a9d70555",
//       subtitle: "+30 books",
//       onPressed: () {}),
//   CardFb1(
//       text: "SeaFloor",
//       imageUrl:
//           "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/illustrations%2Fundraw_Working_late_re_0c3y%201.png?alt=media&token=7b880917-2390-4043-88e5-5d58a9d70555",
//       subtitle: "+30 books",
//       onPressed: () {})
// ];

class SwipeImage extends StatelessWidget {
  const SwipeImage({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.1),
                image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover, alignment: const Alignment(0.3, 0))),
          )),
      Center(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.grey.shade200.withOpacity(0.6)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 60,
                    ),
                    const ListTile(
                      leading: const Text('Instructions'),
                      title: const Text(
                          'More than 10,000 earthquake tremors hit the United States each year. These earthquake tremors can be deadly. For instance, on July 27, 1976, an earthquake that struck the city of Tangshan, China, killing 250,000 people and injuring 500,000 more. This guide tells you how to prepare for an earthquake, what to do during an earthquake, and what steps to take after an earthquake has hit.'),
                    ),
                    const ListTile(
                      leading: const Text('Location Start Point'),
                      title: const Text('One eastwood ave t2'),
                    ),
                  ],
                )),
          ),
        ),
      ),
    ]);
  }
}

class SwipeCardsFB extends StatefulWidget {
  SwipeCardsFB({
    Key? key,
    required this.cards,
    required this.onRightSwipe,
    required this.onLeftSwipe,
    required this.onUpSwipe,
    this.cardResetDuration = 400, //milliseconds
    this.maxTiltAngle = 25, //degrees
    this.sideSwipeSensitivity = 100, //distance the user must swipe left or right for action
    this.upSwipeSensitivity = 50,
  }) : super(key: key);

  final int cardResetDuration;
  final List<Widget> cards;
  final double maxTiltAngle;
  final Function onLeftSwipe;
  final Function onRightSwipe;
  final Function onUpSwipe;
  final double sideSwipeSensitivity;
  final double upSwipeSensitivity;

  @override
  _SwipeCardsFBState createState() => _SwipeCardsFBState();
}

class _SwipeCardsFBState extends State<SwipeCardsFB> {
  double _angle = 0;
  Offset _dragPosition = Offset.zero;
  bool _isDragging = false;
  late Size _screenSize;

  Offset get dragPosition => _dragPosition;

  Widget buildCard(Widget card) => Container(
        child: card,
      );

  Widget buildFrontCard(Widget card) => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          int duration;
          if (_isDragging) {
            //Since User is Dragging card, no animation is necessary, thus duration = 0)
            duration = 0;
          } else {
            duration = widget.cardResetDuration; //User has released card, animation required for card to fly away or reset to origin
          }

          //Creates Transform Matrix For Card Tilt and drag animation
          final center = constraints.smallest.center(Offset.zero);
          final radians = _toRadians(_angle);
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy) //centers the axis of rotation
            ..rotateZ(radians)
            ..translate(-center.dx, -center.dy) //reverts to original axis
            ..translate(dragPosition.dx, dragPosition.dy);

          return AnimatedContainer(duration: Duration(milliseconds: duration), transform: rotatedMatrix, child: card);
        }),
        onPanUpdate: (details) {
          setState(() {
            _dragPosition += details.delta;
            _angle = widget.maxTiltAngle * _dragPosition.dx / _screenSize.width;
          });
        },
        onPanEnd: (details) async {
          _isDragging = false;

          if (_isUpSwipe(_dragPosition.dy, widget.upSwipeSensitivity)) {
            _flyOutUp();
            widget.onUpSwipe();
            _toNextCard();
          } else if (_isRightSwipe(_dragPosition.dx, widget.sideSwipeSensitivity)) {
            _flyOutRight();
            widget.onRightSwipe();
            _toNextCard();
          } else if (_isLeftSwipe(_dragPosition.dx, widget.sideSwipeSensitivity)) {
            _flyOutLeft();
            widget.onLeftSwipe();
            _toNextCard();
          } else {
            _resetPosition();
          }
        },
        onPanStart: (details) {
          setState(() {
            _isDragging = true;
          });
        },
      );

  void _toNextCard() async {
    if (cards.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 400));

    cards.removeLast();
    setState(() {
      _isDragging = true;
    });
    _resetPosition();
  }

  void _flyOutLeft() {
    setState(() {
      _angle = -widget.maxTiltAngle;
      _dragPosition += Offset(-2 * _screenSize.width, 0);
    });
  }

  void _flyOutRight() {
    setState(() {
      _angle = widget.maxTiltAngle;
      _dragPosition += Offset(2 * _screenSize.width, 0);
    });
  }

  void _flyOutUp() {
    setState(() {
      _dragPosition += Offset(0, -2 * _screenSize.height);
    });
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  bool _isRightSwipe(double dx, double sideSwipeSensitivity) {
    return dx >= sideSwipeSensitivity;
  }

  bool _isLeftSwipe(double dx, double sideSwipeSensitivity) {
    return dx <= -sideSwipeSensitivity;
  }

  bool _isUpSwipe(double dy, double upSwipeSensitivity) {
    return dy <= -upSwipeSensitivity;
  }

  void _resetPosition() {
    setState(() {
      _dragPosition = Offset.zero;
      _angle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Stack(
        children: cards.map<Widget>((widget) {
      return widget == cards.last ? buildFrontCard(widget) : buildCard(widget);
    }).toList());
  }
}
