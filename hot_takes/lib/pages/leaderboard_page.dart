import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:flutter/foundation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:hot_takes/components/takes_state.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  State<LeaderboardPage> createState() => _LeaderboardPage();
}

class _LeaderboardPage extends State<LeaderboardPage> {
  List<Take>? takes = null;

  Future<List<Take>> getTop(TakesState t) async {
    return t.getTopN(10);
  }

  double GetAgreePct(Take t)
  {
    int numerator = t.agreeCount;
    int denominator = t.agreeCount+t.disagreeCount;
    double result = ((numerator/denominator)*100);

    return double.parse((result).toStringAsFixed(2));
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
          leading: Tab(icon: new Image.asset("assets/img/take_icon.png"), text: "Browse"),
          title: Text("Hot Takes"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: FutureBuilder<List<Take>>(
            future: getTop(takeState),
            builder: (context, snapshot) {
              List<Widget> children;
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                takes = snapshot.data;
                children = <Widget>[
                  SizedBox(height: 24),
                  Text(
                    "Top Takes",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 24),
                  Expanded(
                      child: ListView.builder(
                    itemCount: takes!.length,
                    prototypeItem: Card(
                        child: ListTile(
                      title:
                          Text(takes!.isNotEmpty ? takes!.first.takeName : ""),
                      subtitle: Text(""),
                    )),
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                        leading: Text("${takes!.isNotEmpty ? GetAgreePct(takes![index]) : 0}%"),
                        title: Text(
                            takes!.isNotEmpty ? takes![index].takeName : ""),
                        subtitle: Text(
                            "Agrees: ${takes!.isNotEmpty ? takes![index].agreeCount : ""}  Disagrees: ${takes!.isNotEmpty ? takes![index].disagreeCount : ""}"),
                        trailing: Text(
                            "Author: ${takes!.isNotEmpty ? takes![index].userName : ""}"),
                      ));
                    },
                  ))
                ];
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                    width: 80,
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      'Retrieving Data',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ));
  }
}
