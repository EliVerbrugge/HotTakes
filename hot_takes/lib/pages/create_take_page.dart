import 'package:flutter/material.dart';
import 'package:hot_takes/components/takes_list.dart';
import 'package:hot_takes/components/topic.dart';
import 'package:hot_takes/components/topic_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/take.dart';
import '../components/take_utils.dart';

class CreateTakePage extends StatefulWidget {
  @override
  State<CreateTakePage> createState() => _CreateTakePage();
}

class _CreateTakePage extends State<CreateTakePage> {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  Topic? _selected = Topic("Movies", 2, TopicType.Category);
  final myController = TextEditingController();

  void onSubmit() {
    String take_name = myController.text;
    Topic val = _selected!;
    createTake(take_name, val);
  }

  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: myController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your take',
                ),
              ),
            ),
            SizedBox(height: 24),
            Text("Topic:"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: FutureBuilder(
                  future: getAllTopics(myUserId),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('none');
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                        return Text('');
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text(
                            '${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          );
                        } else {
                          return DropdownButton<Topic>(
                            isExpanded: true,
                            items:
                                snapshot.data?.map((Topic dropDownStringItem) {
                              return DropdownMenuItem<Topic>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem.topic_name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selected = value!;
                              });
                            },
                            value: _selected,
                          );
                        }
                    }
                  }),
            ),
            SizedBox(height: 24),
            OutlinedButton(onPressed: onSubmit, child: Text("Submit"))
          ],
        )));
  }
}
