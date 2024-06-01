import 'package:flutter/material.dart';

import '../topic.dart';

class TopicWidget extends StatelessWidget {
  final Topic? topic;

  const TopicWidget({required this.topic});

  Widget buildTagButton(Topic topic) {
    TextStyle buttonStyle;
    Icon tagIcon;

    if (topic.type == TopicType.Private) {
      tagIcon = new Icon(
        Icons.lock,
        color: Color.fromRGBO(175, 0, 123, 1),
      );
    } else {
      tagIcon = new Icon(
        Icons.tag,
        color: Color.fromRGBO(175, 0, 123, 1),
      );
    }

    buttonStyle =
        new TextStyle(fontSize: 15, color: Color.fromRGBO(175, 0, 123, 1));

    return TextButton(
        onPressed: () {},
        child: Row(
          children: [
            tagIcon,
            Text(
              topic.topic_name,
              style: buttonStyle,
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          topic != null ? buildTagButton(topic!) : Text("No Topic")
        ]),
      ],
    );
  }
}
