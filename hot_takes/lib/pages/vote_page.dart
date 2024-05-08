import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:flutter/foundation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

import 'package:hot_takes/components/takes_state.dart';
import 'package:hot_takes/components/card_components/card_panel.dart';
import 'package:hot_takes/components/card_components/card_content.dart';

class VotePage extends StatelessWidget {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  User? _user = Supabase.instance.client.auth.currentUser!;
  String profileUrl = "";
  String profileName = "";
  static bool firstTime = true;

  VotePage() {}

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //

    final takeState = Provider.of<TakesState>(context);
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(
          //leading: Image.asset("assets/img/take_icon.png"),
          title: Text("Hot Takes"),
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
              color: Color.fromRGBO(175, 0, 123, 1),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        body: Container(
          child: !takeState.isOutOfCards()
              ? AppinioSwiper(
                  // Card Swiping Characteristics
                  onEnd: () {
                    firstTime = false;
                  },
                  onSwipeEnd: (previousIndex, targetIndex, activity) {
                    if (activity is Swipe) {
                      print("prev take: ${takeState.getName(previousIndex)}");
                      print("direction: ${activity.direction}");
                      if (activity.direction == AxisDirection.right) {
                        takeState.agree(previousIndex);
                      } else if (activity.direction == AxisDirection.left) {
                        takeState.disagree(previousIndex);
                      }
                      takeState.voted();
                    }
                  },
                  cardCount: takeState.takes.length,
                  threshold: 50,
                  maxAngle: 30,

                  // Actual Take Object
                  cardBuilder: (BuildContext context, int index) {
                    /* 
                    Card is divided into two main parts, we will call them
                    Content and Panel. Content is the top half, and Panel is
                    the bottom. Below will go over what info each will have

                    Content:
                      Top Left: Authors name
                    

                    */
                    return Column(children: [
                      // Content
                      Expanded(
                          child: TakeCardContent(
                        takeArtist: takeState.getUserName(index),
                        takeContent: takeState.getName(index),
                      )),
                      //Panel
                      TakeCardPanel(
                        agreeCount: takeState.getAgrees(index),
                        disagreeCount: takeState.getDisagrees(index),
                        isIcyTake: takeState.getIcyOrSpicy(index),
                        spicyness: takeState.getSpicyness(index),
                        takeTags: takeState.getTagInfo(index),
                      ),
                    ]);
                  })
              : Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Out of Takes",
                        style: TextStyle(fontSize: 25),
                      ),
                      Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                        size: 40,
                      )
                    ],
                  ),
                ),
        ));
  }
}
