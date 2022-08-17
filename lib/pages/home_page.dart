import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: SwipeCardsFB(cards: cards, onRightSwipe: () {}, onLeftSwipe: () {}, onUpSwipe: () {}));
  }
}

//- - - - - - - - - Instructions - - - - - - - - - - - - - - - - - -
//
// Pass cards to be swiped into the cards parameter. Any Widget can be provided,
// although unexpected behavior may occur with widgets that are especially small or large
//
// MUST IMPORT MATH for Pi: import 'dart:math';
//
// Coming Soon:
//    - Controller Class for controlling swipecard outside of widget.
//    - Buttons that swipe left or right

//- - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -

// -=-=- (Dating App images) -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

//COPY Paste below code to test functionality with demo images

const List<String> urls = [
  "https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8d29tYW4lMjBwb3J0cmFpdHxlbnwwfHwwfHw%3D&w=1000&q=80",
  "https://images.unsplash.com/photo-1561442748-c50715dc32f6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXw5MjU4MjM3fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
  "https://images.unsplash.com/photo-1589156191108-c762ff4b96ab?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8YmxhY2slMjB3b21hbiUyMHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
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
  final String url;
  const SwipeImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover, alignment: Alignment(0.3, 0))),
          )),
    );
  }
}

class SwipeCardsFB extends StatefulWidget {
  final int cardResetDuration;
  final double maxTiltAngle;
  final double sideSwipeSensitivity;
  final double upSwipeSensitivity;

  final Function onRightSwipe;
  final Function onLeftSwipe;
  final Function onUpSwipe;
  final List<Widget> cards;
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

  @override
  _SwipeCardsFBState createState() => _SwipeCardsFBState();
}

class _SwipeCardsFBState extends State<SwipeCardsFB> {
  Offset _dragPosition = Offset.zero;
  double _angle = 0;

  Offset get dragPosition => _dragPosition;

  bool _isDragging = false;
  late Size _screenSize;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Stack(
        children: cards.map<Widget>((widget) {
      return widget == cards.last ? buildFrontCard(widget) : buildCard(widget);
    }).toList());
  }

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
    await Future.delayed(Duration(milliseconds: 400));

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
}
