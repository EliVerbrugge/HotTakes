import 'dart:math';

enum TopicType {
  Private(),
  Category(),
  Sponsored();
}

class Topic {
  TopicType type = TopicType.Private;
  String topic_name = "";
  int topic_id = -1;

  Topic(String _topic_name, int _topic_id, TopicType _type) {
    topic_name = _topic_name;
    topic_id = _topic_id;
    type = _type;
  }

  Topic.fromJson(Map<String, dynamic> json) {
    topic_name = json['topic_name'] as String;
    topic_id = json['topic_id'] as int;
    type = TopicType.values.byName(json['topic_type']);
  }

  @override
  bool operator ==(Object other) =>
      other is Topic &&
      other.type == type &&
      other.topic_id == topic_id &&
      other.topic_name == topic_name;
}
