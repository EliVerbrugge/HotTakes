import 'package:flutter/material.dart';
import 'package:hot_takes/components/takes_list.dart';
import 'package:hot_takes/components/topic.dart';
import 'package:hot_takes/components/topic_utils.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/take.dart';
import '../components/take_utils.dart';
import '../components/takes_model.dart';

class SelectTopicPage extends StatefulWidget {
  @override
  State<SelectTopicPage> createState() => _SelectTopicPage();
}

class _SelectTopicPage extends State<SelectTopicPage> {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  final myController = TextEditingController();
  late List<String> topic_names;

  late Map<String, bool> checkboxes;

  Widget build(BuildContext context) {
    final takeModel = Provider.of<TakeModel>(context);
    checkboxes = takeModel.getTopicNames();
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
          children: <Widget>[
            Text(
              "Select topics you are interested in",
              style: TextStyle(fontSize: 25),
            ),
            Flexible(
                child: ListView.builder(
              key: PageStorageKey("Test"),
              itemCount: checkboxes.length,
              itemBuilder: (context, index) {
                String key = checkboxes.keys.elementAt(index);

                return CheckboxListTile(
                  title: new Text(key),
                  value: checkboxes[key],
                  onChanged: (bool? value) {
                    if (value == true) {
                      setState(() {
                        takeModel.addTopic(key);
                      });
                    } else if (value == false) {
                      setState(() {
                        takeModel.removeTopic(key);
                      });
                    }
                  },
                );
              },
            )),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
        )));
  }
}
