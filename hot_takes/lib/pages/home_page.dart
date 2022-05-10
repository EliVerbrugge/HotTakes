import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_takes/components/authentication.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  User? _user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    final takeState = Provider.of<TakesState>(context);
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(
          title: Text("HotTakes"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
            child: Column(children: [
          SizedBox(
            height: 16,
          ),
          ProfilePic(),
          SizedBox(
            height: 8,
          ),
          Text(_user!.displayName.toString()),
          SizedBox(
            height: 16,
          ),
          ListView.builder(
              itemCount: takeState.takes.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) => Card(
                    child: Column(children: [
                      Text("${takeState.takes[index].takeName}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.favorite)),
                            TextSpan(
                                text: '${takeState.takes[index].agreeCount}'),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.cancel)),
                            TextSpan(
                                text:
                                    '${takeState.takes[index].disagreeCount}'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () => {
                                    takeState
                                        .agree(takeState.takes[index].uniqueID)
                                  },
                              child: Icon(Icons.add)),
                          ElevatedButton(
                              onPressed: () => {
                                    takeState.disagree(
                                        takeState.takes[index].uniqueID)
                                  },
                              child: Icon(Icons.remove)),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () => {
                                takeState
                                    .deleteTake(takeState.takes[index].uniqueID)
                              },
                          child: Icon(Icons.delete))
                    ]),
                  )),
        ])),
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
                          child: const Text('Approve'),
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

class ProfilePic extends StatelessWidget {
  User? _user = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        child: Image.network(
          _user!.photoURL!,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
