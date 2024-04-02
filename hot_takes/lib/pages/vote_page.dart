import 'dart:html';

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
                height: MediaQuery.of(context).size.height * .75,
                width: MediaQuery.of(context).size.width * .7,
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    "${takeState.getName(index)}",
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    )),
                                              ],
                                            )),
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
                        )
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
                ),
              ),
            ],
          )
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
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Submit'),
                          onPressed: () {
                            if (myController.text.isNotEmpty) {
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
