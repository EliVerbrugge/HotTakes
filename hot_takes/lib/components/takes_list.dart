import 'package:flutter/material.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:provider/provider.dart';

class TakesList extends StatefulWidget {
  final dataFunc;

  TakesList({required this.dataFunc});

  @override
  State<StatefulWidget> createState() => _TakesList();
}

class _TakesList extends State<TakesList> {
  List<Take>? takes = null;
  late final Future<List<Take>> dataSource = widget.dataFunc;

  double GetAgreePct(Take t) {
    int numerator = t.agreeCount;
    int denominator = t.agreeCount + t.disagreeCount;
    double result = ((numerator / denominator) * 100);

    return double.parse((result).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    return FutureBuilder<List<Take>>(
      future: dataSource,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          takes = snapshot.data;
          child = SingleChildScrollView(
              child: ListView.builder(
            itemCount: takes!.length,
            shrinkWrap: true,
            prototypeItem: Card(
                child: ListTile(
              title: Text(takes!.isNotEmpty ? takes!.first.takeName : ""),
              subtitle: Text(""),
            )),
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                leading: Text(
                    "${takes!.isNotEmpty ? GetAgreePct(takes![index]) : 0}%"),
                title: Text(takes!.isNotEmpty ? takes![index].takeName : ""),
                subtitle: Text(
                    "Agrees: ${takes!.isNotEmpty ? takes![index].agreeCount : ""}  Disagrees: ${takes!.isNotEmpty ? takes![index].disagreeCount : ""}"),
                trailing: Text(
                    "Author: ${takes!.isNotEmpty ? takes![index].userName : ""}"),
              ));
            },
          ));
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError) {
          child = Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 20),
            ),
          );
        } else {
          child = Center(
              child: SizedBox(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
            width: 80,
            height: 80,
          ));
        }
        return Flexible(child: child);
      },
    );
  }
}
