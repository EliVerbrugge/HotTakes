import 'package:flutter/material.dart';
import 'package:hot_takes/components/takes_list.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  State<LeaderboardPage> createState() => _LeaderboardPage();
}

class _LeaderboardPage extends State<LeaderboardPage> {
  List<Take>? takes = null;

  Future<List<Take>> getTop(TakesState t) async {
    return t.getTopN(10);
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
          leading: Tab(
              icon: new Image.asset("assets/img/take_icon.png"),
              text: "Browse"),
          title: Text("Hot Takes"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 24),
            Text(
              "Top Takes",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 24),
            TakesList(dataFunc: getTop(takeState))
          ],
        )));
  }
}
