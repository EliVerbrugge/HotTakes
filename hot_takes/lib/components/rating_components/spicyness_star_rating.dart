import 'package:flutter/material.dart';

/*
TODO LIST:

>Maybe pass in color
>Change how icy/spicy is handled

*/

class SpicyRating extends StatelessWidget {
  final int iconCount;
  final int rating;
  final bool isIcyTake;

  SpicyRating({this.iconCount = 5, this.rating = 0, this.isIcyTake = false});

  Widget buildSpicyRating(BuildContext context, int index) {
    Icon icon;

    if (isIcyTake) {
      if (index >= rating) {
        icon = new Icon(
          Icons.ac_unit_outlined,
          color: Color.fromRGBO(69, 69, 69, 1),
        );
      } else {
        icon = new Icon(
          Icons.ac_unit,
          color: Color.fromRGBO(5, 99, 200, 1),
        );
      }
    } else {
      if (index >= rating) {
        icon = new Icon(
          Icons.local_fire_department_outlined,
          color: Color.fromRGBO(69, 69, 69, 1),
        );
      } else {
        icon = new Icon(
          Icons.local_fire_department,
          color: Color.fromRGBO(239, 63, 0, 1),
        );
      }
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: new List.generate(
            iconCount, (index) => buildSpicyRating(context, index)));
  }
}
