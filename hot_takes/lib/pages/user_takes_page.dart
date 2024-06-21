import 'package:flutter/material.dart';
import 'package:hot_takes/components/takes_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/takes/take.dart';
import '../components/takes/take_utils.dart';

class MyTakesPage extends StatefulWidget {
  @override
  State<MyTakesPage> createState() => _MyTakesPage();
}

class _MyTakesPage extends State<MyTakesPage> {
  List<Take>? takes = null;
  final myUserId = Supabase.instance.client.auth.currentUser!.id;

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 24),
            Text(
              "My Takes",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 24),
            TakesList(dataFunc: getUsersTakes(myUserId))
          ],
        )));
  }
}
