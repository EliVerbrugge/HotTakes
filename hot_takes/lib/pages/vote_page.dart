import 'dart:html';

import 'package:flutter/material.dart';
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
          leading: Icon(MdiIcons.fire),
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
                  child: !takeState.outOfCards()
                      ? AppinioSwiper(
                          cardBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              alignment: Alignment.center,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${takeState.getName(index)}",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 25),
                                    ),
                                    Text(
                                      "Agrees: ${takeState.getAgrees(index)}",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 25),
                                    ),
                                    Text(
                                      "Disagrees: ${takeState.getDisagrees(index)}",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 25),
                                    )
                                  ]),
                            );
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
                              takeState.loadAhead();
                            }
                          },
                          cardCount: takeState.takes.length,
                        )
                      : Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Out of Takes", style: TextStyle(fontSize: 25),), Icon(Icons.close_rounded, color: Colors.red, size: 40,)],
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
                            Navigator.of(context).pop();
                            takeState.createTake(myController.text);
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
