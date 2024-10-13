import 'package:flutter/material.dart';
import 'package:hot_takes/components/topics/topic.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/takes/takes_model.dart';

class SelectTopicPage extends StatefulWidget {
  @override
  State<SelectTopicPage> createState() => _SelectTopicPage();
}

class _SelectTopicPage extends State<SelectTopicPage> {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  final myController = TextEditingController();
  late List<String> topic_names;

  late Map<Topic, bool> checkboxes;

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
            Flexible(
                child: ListView.builder(
              key: PageStorageKey("Test"),
              itemCount: checkboxes.length,
              itemBuilder: (context, index) {
                Topic key = checkboxes.keys.elementAt(index);

                return Card(
                    borderOnForeground: false,
                    child: JoinButtonTile(
                        title: key.topic_name,
                        topicKey: key,
                        isJoined: checkboxes[key]!));
              },
            )),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
        )));
  }
}

class JoinButtonTile extends StatefulWidget {
  final String title;
  final bool isJoined;
  final Topic topicKey;

  const JoinButtonTile({
    Key? key,
    required this.title,
    required this.topicKey,
    required this.isJoined,
  }) : super(key: key);

  @override
  _JoinButtonTileState createState() => _JoinButtonTileState();
}

class _JoinButtonTileState extends State<JoinButtonTile> {
  late bool _isJoined;

  @override
  void initState() {
    super.initState();
    _isJoined = widget.isJoined;
  }

  @override
  Widget build(BuildContext context) {
    final takeModel = Provider.of<TakeModel>(context);

    return ListTile(
      title: Text(widget.title),
      trailing: ElevatedButton(
        onPressed: () {
          setState(() {
            if (_isJoined == false) {
              setState(() {
                takeModel.addTopic(widget.topicKey);
              });
            } else if (_isJoined == true) {
              setState(() {
                takeModel.removeTopic(widget.topicKey);
              });
            }
            _isJoined = !_isJoined;
          });
        },
        child: Text(_isJoined ? 'Unfollow' : 'Follow'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _isJoined ? Colors.red : Colors.blue,
        ),
      ),
    );
  }
}
