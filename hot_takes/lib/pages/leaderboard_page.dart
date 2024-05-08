import 'package:flutter/material.dart';
import 'package:hot_takes/components/takes_list.dart';

import '../components/take.dart';
import '../components/take_utils.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  State<LeaderboardPage> createState() => _LeaderboardPage();
}

class _LeaderboardPage extends State<LeaderboardPage> {
  List<Take>? takes = null;

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(
          leading: Image.asset("assets/img/take_icon.png"),
          title: Text("Hot Takes"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text(
              "Top Takes",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 24),
            TakesList(dataFunc: getTopNTakes(10))
          ],
        )));
  }
}
