import 'package:flutter/material.dart';
import 'package:hot_takes/components/takes_list.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyTakesPage extends StatefulWidget {
  @override
  State<MyTakesPage> createState() => _MyTakesPage();
}

class _MyTakesPage extends State<MyTakesPage> {
  List<Take>? takes = null;
  final myUserId = Supabase.instance.client.auth.currentUser!.id;

  Future<List<Take>> getTakes(TakesState t) async {
    return t.getUsersTakes(myUserId);
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
              "My Takes",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 24),
            TakesList(dataFunc: getTakes(takeState))
          ],
        )));
  }
}
