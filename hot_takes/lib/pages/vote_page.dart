import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:flutter/foundation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class VotePage extends StatelessWidget {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  User? _user = Supabase.instance.client.auth.currentUser!;
  String profileUrl = "";
  String profileName = "";
  static bool firstTime = true;
  final AppinioSwiperController controller = AppinioSwiperController();

  VotePage() {}

  Widget getUserWidget(AsyncSnapshot<Object?> snapshot) {
    String? username = "";
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      username = snapshot.data as String?;
      return Text(
        "Author: ${username}",
        style: TextStyle(color: Colors.black, fontSize: 25),
      );
    } else {
      return Text(
        "Author: Unknown",
        style: TextStyle(color: Colors.black, fontSize: 25),
      );
    }
  }

  //swipe card to the left side
Widget swipeLeftButton(AppinioSwiperController controller) {
  return ListenableBuilder(
    listenable: controller,
    builder: (context, child) {
      final SwiperPosition? position = controller.position;
      final SwiperActivity? activity = controller.swipeActivity;
      final double horizontalProgress =
          (activity is Swipe || activity == null) &&
                  position != null &&
                  position.offset.toAxisDirection().isHorizontal
              ? -1 * position.progressRelativeToThreshold.clamp(-1, 1)
              : 0;
      final Color color = Color.lerp(
        const Color(0xFFFF3868),
        Colors.grey,
        (-1 * horizontalProgress).clamp(0, 1),
      )!;
      return GestureDetector(
        onTap: () => controller.swipeLeft(),
        child: Transform.scale(
          // Increase the button size as we swipe towards it.
          scale: 1 + .1 * horizontalProgress.clamp(0, 1),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.9),
                  spreadRadius: -10,
                  blurRadius: 20,
                  offset: const Offset(0, 20), // changes position of shadow
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    final takeState = Provider.of<TakesState>(context);
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(
          leading: Image.asset("assets/img/take_icon.png"),
          title: Text("Hot Takes"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * (GetPlatform.isMobile ? 0.65 : 0.75),
                width: MediaQuery.of(context).size.width * (GetPlatform.isMobile ? 0.7 : 0.4),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    bottom: 40,
                  ),
                  child: !takeState.isOutOfCards()
                      ? AppinioSwiper(
                          cardBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                alignment: Alignment.center,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.red,
                                                  ],
                                                )),
                                            height: 50,
                                            child: Row(children: [Flexible(
                                              child: Text(
                                                  "${takeState.getName(index)}",
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  )),
                                            ),], mainAxisAlignment: MainAxisAlignment.center,)),
                                        flex: 6,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Author: ${takeState.getUserName(index)}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: GetPlatform.isMobile
                                                  ? 15
                                                  : 25),
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Agrees",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: GetPlatform.isMobile
                                                      ? 15
                                                      : 25),
                                            ),
                                            Icon(
                                              Icons.arrow_circle_up,
                                              color: Colors.green,
                                            ),
                                            Text(
                                              ": ${takeState.getAgrees(index)}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: GetPlatform.isMobile
                                                      ? 15
                                                      : 25),
                                            ),
                                          ],
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Disagrees: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: GetPlatform.isMobile
                                                      ? 15
                                                      : 25),
                                            ),
                                            Icon(
                                              Icons.arrow_circle_down,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              ": ${takeState.getDisagrees(index)}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: GetPlatform.isMobile
                                                      ? 15
                                                      : 25),
                                            ),
                                          ],
                                        ),
                                        flex: 1,
                                      ),
                                    ]),
                              ))
                            ]);
                          },
                          onEnd: () {
                            firstTime = false;
                          },
                          onSwipeEnd: (previousIndex, targetIndex, activity) {
                            if (activity is Swipe) {
                              print(
                                  "prev take: ${takeState.getName(previousIndex)}");
                              print("direction: ${activity.direction}");
                              if (activity.direction == AxisDirection.right) {
                                takeState.agree(previousIndex);
                              } else if (activity.direction ==
                                  AxisDirection.left) {
                                takeState.disagree(previousIndex);
                              }
                              takeState.voted();
                            }
                          },
                          cardCount: takeState.takes.length,
                          swipeOptions:
                              SwipeOptions.only(left: true, right: true),
                          controller: controller,
                        )
                      : Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Out of Takes",
                                style: TextStyle(fontSize: 25),
                              ),
                              Image.asset("assets/img/crying.png", width: 100, height: 100,),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
          !takeState.isOutOfCards() ? ElevatedButton(onPressed: () {takeState.skip(controller.cardIndex!); controller.swipeDown();} , child: Text('Skip')) : SizedBox(),
        ]),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 8,
            ),
            FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                final myController = TextEditingController();

                await showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('What is the take?'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            TextField(
                              controller: myController,
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Submit'),
                          onPressed: () {
                            if (myController.text.trim().isNotEmpty) {
                              Navigator.of(context).pop();
                              takeState.createTake(myController.text);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Needs to have text')),
                              );
                            }
                          },
                        ),
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ));
  }
}