import 'dart:math';

import 'topic.dart';

enum Opinion {
  Agree(name: "Agree"),
  Disagree(name: "Disagree"),
  Neutral(name: "Neutral");

  const Opinion({required this.name});

  final String name;
}

class Take {
  int take_id = 0;
  int agreeCount = 0;
  int disagreeCount = 0;
  int spicyness = 0;
  bool isIcy = Random().nextBool();
  DateTime created = DateTime.fromMicrosecondsSinceEpoch(0);
  String takeName = "";
  String userId = "";
  String? userName = "";
  Topic? topic;

  Take(String name, int agrees, int disagrees, bool isIcy, int id,
      DateTime date, String user_id, String? user_name,
      {Topic? t = null}) {
    takeName = name;
    agreeCount = agrees;
    disagreeCount = disagrees;
    isIcy = isIcy;
    take_id = id;
    userId = user_id;
    created = date;
    userName = user_name;
    topic = t;

    // Spicyness is the number of disagrees as ratio of total opinions, out of 5
    if (agreeCount > 0 || disagreeCount > 0) {
      spicyness = ((disagreeCount / (agreeCount + disagreeCount)) * 5).toInt();
    } else {
      spicyness = 0;
    }
  }

  Take.fromJson(Map<String, dynamic> json) {
    takeName = json['take'] as String;
    agreeCount = json['agrees'] as int;
    disagreeCount = json['disagrees'] as int;
    take_id = json['take_id'] as int;
    userId = json['author_user_id'] as String;
    created = DateTime.parse(json['created_at']);
    userName = json['user_name'] as String?;

    if (json.containsKey("topic_name")) {
      topic = Topic(json['topic_name'], json['topic_id'],
          TopicType.values.byName(json['topic_type']));
    }

    // Spicyness is the number of disagrees as ratio of total opinions, out of 5
    if (agreeCount > 0 || disagreeCount > 0) {
      spicyness = ((disagreeCount / (agreeCount + disagreeCount)) * 5).toInt();
    } else {
      spicyness = 0;
    }
  }
}
