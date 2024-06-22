import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:go_router/go_router.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hot_takes/components/takes/takes_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

import '../components/card_components/card_panel.dart';
import '../components/card_components/card_content.dart';
import '../components/takes/take_utils.dart';
import '../components/takes/take.dart';

class SpecificTakePage extends StatelessWidget {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  String profileUrl = "";
  String profileName = "";
  final AppinioSwiperController controller = AppinioSwiperController();
  late int this_take_id;
  late Take? t;

  SpecificTakePage({required take_id}) {
    this_take_id = take_id;
  }

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    final takeModel = Provider.of<TakeModel>(context);
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(
          title: Text("Hot Takes"),
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
              color: Color.fromRGBO(175, 0, 123, 1),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        body: FutureBuilder(
            future: getTake(myUserId, this_take_id),
            builder: (context, snapshot) {
              Widget child;
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                t = snapshot.data;
                child = Container(
                  child: AppinioSwiper(
                      // Card Swiping Characteristics
                      onSwipeEnd: (previousIndex, targetIndex, activity) {
                        if (activity is Swipe) {
                          print(
                              "prev take: ${takeModel.getName(previousIndex)}");
                          print("direction: ${activity.direction}");
                          if (activity.direction == AxisDirection.right) {
                            vote(t!, myUserId, Opinion.Agree);
                          } else if (activity.direction == AxisDirection.left) {
                            vote(t!, myUserId, Opinion.Disagree);
                          }
                          context.go("/Home");
                        }
                      },
                      cardCount: 1,
                      swipeOptions: SwipeOptions.only(left: true, right: true),

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
                            takeArtist: t!.userName!,
                            takeContent: t!.takeName,
                          )),
                          //Panel
                          TakeCardPanel(
                            agreeCount: t!.agreeCount,
                            disagreeCount: t!.disagreeCount,
                            isIcyTake: t!.isIcy,
                            takeId: t!.take_id,
                            topic: t!.topic,
                            spicyness: t!.spicyness,
                          ),
                        ]);
                      }),
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasError) {
                child = Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasData) {
                child = Row(children: [
                  Expanded(
                      child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already voted on that take",
                          style: TextStyle(fontSize: 25),
                        ),
                        Image.asset(
                          "assets/img/crying.png",
                          width: 100,
                          height: 100,
                        )
                      ],
                    ),
                  ))
                ]);
              } else {
                child = Center(
                    child: SizedBox(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                  width: 80,
                  height: 80,
                ));
              }
              return Flexible(child: child);
            }));
  }
}
