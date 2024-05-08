import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';

/*
TODO LIST:

>This should be a stateless widget that takes in _spicynessVote and a function
    to update the parent when gestureDetector triggers. Theres no reason for
    this to maintain its own state. Once I modify IO swiper then it will
    take care of the voting

>Honestly a lot about this should be looked at, not positive on what though

*/

class TakeCardContent extends StatefulWidget {
  final String takeArtist;
  final String takeContent;

  const TakeCardContent(
      {super.key, this.takeArtist = "No One", this.takeContent = "Nothing"});

  @override
  State<TakeCardContent> createState() => _TakeCardContentState();
}

class _TakeCardContentState extends State<TakeCardContent>
    with SingleTickerProviderStateMixin {
  int _spicynessVote = 0; // 0 is default, -1 is icy, 1 is spicy

  /*  LinearGradient spicyGradientStupid = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(77, 10, 29, 1),
    ],
  ); */

  LinearGradient spicyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(77, 10, 29, 1),
      Color.fromRGBO(124, 6, 31, 1),
      Color.fromRGBO(169, 20, 20, 1),
      //Color.fromRGBO(230, 130, 16, 1),
    ],
  );
  LinearGradient defaultGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(169, 20, 20, 1),
      Color.fromRGBO(175, 0, 123, 1),
      Color.fromRGBO(16, 76, 229, 1),
    ],
  );
  LinearGradient icyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(16, 75, 230, 1),
      Color.fromRGBO(16, 100, 230, 1),
      Color.fromRGBO(16, 125, 230, 1),

      //Color.fromRGBO(9, 74, 123, 1),
    ],
  );

  void _handleSpicynessVote(TapDownDetails details, BuildContext context) {
    var tapHeight = details.localPosition.dy;
    RenderBox cardBox = context.findRenderObject() as RenderBox;
    var widgetHeight = cardBox.size.height;

    // If the position is above the halfway point of the widget, vote spicy
    // Appears that it is inverted hence the < rather than >
    if (tapHeight < (widgetHeight / 2)) {
      setState(() {
        // Revert to default if it was icy
        (_spicynessVote == -1) ? (_spicynessVote = 0) : (_spicynessVote = 1);
      });
    } else {
      // Vote was below the halfway point so vote icy
      setState(() {
        // Revert to default if it was spicy
        (_spicynessVote == 1) ? (_spicynessVote = 0) : (_spicynessVote = -1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (TapDownDetails details) =>
          _handleSpicynessVote(details, context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red, Colors.blue],
          ),
        ),
        /* gradient: (_spicynessVote == 0)
                ? (defaultGradient)
                : ((_spicynessVote == 1) ? (spicyGradient) : (icyGradient))), */
        child: Stack(children: [
          // Take Artist's Name
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 15.0, top: 5.0),
            child: Text(
              "${widget.takeArtist} says:",
              style: TextStyle(
                  fontFamily: "Open Sans", //TODO: Get sexy font
                  fontSize: GetPlatform.isMobile ? 15 : 25),
            ),
          ),
          // The Actual Take
          Container(
            alignment: Alignment.center,
            child: Text("${widget.takeContent}",
                style: const TextStyle(
                  fontSize: 20,
                )),
          ),
        ]),
      ),
    );
  }
}
