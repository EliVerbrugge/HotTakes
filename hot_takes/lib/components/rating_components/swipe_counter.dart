import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';

/*
TODO LIST:

>implement

*/

class SwipeCounter extends StatelessWidget {
  final int agreeCount;
  final int disagreeCount;

  SwipeCounter({this.agreeCount = 0, this.disagreeCount = 0});

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Color.fromRGBO(16, 16, 16, 1)),
        color: Color.fromRGBO(16, 16, 16, 1),
      ),
      width: 125,
      margin: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(202, 196, 208, 1),
              ),
              Text(
                "${disagreeCount}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(202, 196, 208, 1),
                    fontSize: GetPlatform.isMobile ? 20 : 25),
              ),
              Container(
                width: 2,
                height: 30,
                color: Color.fromRGBO(69, 69, 69, 1),
              ),
              Text(
                "${agreeCount}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    textBaseline: TextBaseline.alphabetic,
                    color: Color.fromRGBO(202, 196, 208, 1),
                    fontSize: GetPlatform.isMobile ? 20 : 25),
              ),
              Icon(
                Icons.arrow_forward,
                color: Color.fromRGBO(202, 196, 208, 1),
              )
            ],
          ),
        ],
      ),
    );
  }
}
