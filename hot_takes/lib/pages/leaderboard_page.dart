import 'package:flutter/material.dart';
import 'package:hot_takes/components/takes_list.dart';

import '../components/takes/take.dart';
import '../components/takes/take_utils.dart';

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
          //leading: Image.asset("assets/img/take_icon.png"),
          title: Text("Hot Takes"),
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
              color: Color.fromRGBO(175, 0, 123, 1),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: const EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  "Top Takes",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 24),
            TakesList(dataFunc: getTopNTakes(6))
          ],
        )));
  }
}
