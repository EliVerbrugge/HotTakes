import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';

import 'package:hot_takes/components/rating_components/swipe_counter.dart';
import 'package:hot_takes/components/rating_components/spicyness_star_rating.dart';
import 'package:hot_takes/components/tag_components/topic_list.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../topics/topic.dart';

/*
TODO LIST:

(A lot of this will be after direct paths)
>Add function hooks for three top buttons
>Allow tags to be clickable
    Probably create a single function hook that takes the tag name up to parent
>Add a fade so it looks less wonky of a transition from content to panel
>Break out swip_counter into its own object, fix its quirks
    IE: Text sometimes gets in weird place, and could probably be better
>Optimize look for different screens
>bring colors out into an enum/object (material app theme???)
>Add super vote button???
*/

class TakeCardPanel extends StatelessWidget {
  final int disagreeCount;
  final int agreeCount;
  final int spicyness;
  final int takeId;
  final bool isIcyTake;
  final Topic? topic;

  TakeCardPanel({
    this.agreeCount = -1,
    this.disagreeCount = -1,
    required this.takeId,
    this.spicyness = 0,
    this.topic = null,
    this.isIcyTake = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.black,
      ),
      child: Column(children: [
        SizedBox(height: 10),
        // Button row
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Left Side Button
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        side: const BorderSide(width: 0)),
                    onPressed: () async {
                      String toCopy = kDebugMode
                          ? 'http://localhost:3000/Explore/' + takeId.toString()
                          : 'https://hottakes-1a324.web.app/Explore/' +
                              takeId.toString();
                      await Clipboard.setData(ClipboardData(text: toCopy));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Copied link!"),
                          duration: Durations.short1,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.share_outlined,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  )
                ],
              ),
              // Spicy/Icy Ranking
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Color.fromRGBO(16, 16, 16, 1)),
                    color: Color.fromRGBO(16, 16, 16, 1),
                  ),
                  //margin: EdgeInsets.only(top: 20),
                  width: 150,
                  height: 30,
                  child: SpicyRating(
                    rating: spicyness,
                    iconCount: 5,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        side: const BorderSide(width: 0)),
                    onPressed: () {},
                    child: Icon(
                      Icons.bookmark_outline,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  )
                ],
              )
              //Right Side Button
            ]),
        // Top Row Info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
/*             // Left/Right Swipes
            SwipeCounter(
              agreeCount: agreeCount,
              disagreeCount: disagreeCount,
            ), */
          ],
        ),
        SizedBox(height: 10),
        // Tags
        TopicWidget(
          topic: topic,
        ),
      ]),
    );
  }
}
