import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hot_takes/components/takes/take.dart';

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

  // Widget for the agree and disagree counts
  Widget _agreesDisagreesWidget(String disagreeCount, String agreeCount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Agrees: ${agreeCount}"),
        Text("Disagrees: ${disagreeCount}")
      ],
    );
  }

  ///Widget for the take description
  Widget _takeName(String takeName) {
    return Container(
      child: Text(
        takeName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  ///Widget for the take description
  Widget _takeRating(String spicyness) {
    return Container(
      width: 50,
      child: Text(
        spicyness + "%",
        style: const TextStyle(fontSize: 12),
      ),
    );
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
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                leading: _takeRating(GetAgreePct(takes![index]).toString()),
                title: _takeName(takes![index].takeName),
                subtitle: Text(
                    "Author: ${takes!.isNotEmpty ? takes![index].userName : ""}"),
                trailing: _agreesDisagreesWidget(
                    takes![index].disagreeCount.toString(),
                    takes![index].agreeCount.toString()),
                onLongPress: () async {
                  String toCopy = kDebugMode
                      ? 'http://localhost:3000/#/Home/' +
                          takes![index].toString()
                      : 'https://hottakes-1a324.web.app/#/Home/' +
                          takes![index].toString();
                  await Clipboard.setData(ClipboardData(text: toCopy));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Copied link!"),
                      duration: Durations.short1,
                    ),
                  );
                },
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
