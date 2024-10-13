import 'package:flutter/material.dart';
import 'package:hot_takes/components/takes/takes_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

import '../components/card_components/card_panel.dart';
import '../components/card_components/card_content.dart';
import '../components/takes/take.dart';

class VotePage extends StatelessWidget {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  static bool firstTime = true;
  final AppinioSwiperController controller = AppinioSwiperController();

  VotePage() {}

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    final takeModel = Provider.of<TakeModel>(context);
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
        body: !takeModel.initialSetupComplete
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: !takeModel.isOutOfCards()
                    ? AppinioSwiper(
                        // Card Swiping Characteristics
                        onEnd: () {
                          firstTime = false;
                        },
                        onSwipeEnd: (previousIndex, targetIndex, activity) {
                          if (activity is Swipe) {
                            print(
                                "prev take: ${takeModel.getName(previousIndex)}");
                            print("direction: ${activity.direction}");
                            if (activity.direction == AxisDirection.right) {
                              takeModel.vote(previousIndex, Opinion.Agree);
                            } else if (activity.direction ==
                                AxisDirection.left) {
                              takeModel.vote(previousIndex, Opinion.Disagree);
                            }
                          }
                        },
                        cardCount: takeModel.takes.length,
                        swipeOptions:
                            SwipeOptions.only(left: true, right: true),

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
                              takeArtist: takeModel.getUserName(index),
                              takeContent: takeModel.getName(index),
                            )),
                            //Panel
                            TakeCardPanel(
                              agreeCount: takeModel.getAgrees(index),
                              disagreeCount: takeModel.getDisagrees(index),
                              takeId: takeModel.getTakeId(index),
                              isIcyTake: takeModel.getIcyOrSpicy(index),
                              topic: takeModel.getTopic(index),
                              spicyness: takeModel.getSpicyness(index),
                            ),
                          ]);
                        })
                    : Row(children: [
                        Expanded(
                            child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Out of Takes",
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
                      ]),
              ));
  }
}
