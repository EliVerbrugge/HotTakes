import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_takes/authentication.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/takes_state.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  late User _user;

  HomePage(User user) {
    _user = user;
  }

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    final takeState = Provider.of<TakesState>(context);
    //
    return Scaffold(
        appBar: AppBar(
          title: Text("HotTakes"),
        ),
        body: Center(
            child: Column(children: [
          SizedBox(
            height: 16,
          ),
          ClipOval(
            child: Material(
              color: Colors.grey,
              child: Image.network(
                _user.photoURL!,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(_user.displayName.toString()),
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
                      Text("${takeState.takes[index].voteCount}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () => {
                                    takeState.incrementVotes(
                                        takeState.takes[index].uniqueID,
                                        takeState.takes[index].voteCount)
                                  },
                              child: Icon(Icons.add)),
                          ElevatedButton(
                              onPressed: () => {
                                    takeState.decrementVotes(
                                        takeState.takes[index].uniqueID,
                                        takeState.takes[index].voteCount)
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
