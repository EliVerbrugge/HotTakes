class Take {
  int take_id = 0;
  int agreeCount = 0;
  int disagreeCount = 0;
  DateTime created = DateTime.fromMicrosecondsSinceEpoch(0);
  String takeName = "";
  String userId = "";
  String? userName = "";


  Take(String name, int agrees, int disagrees, int id, DateTime date, String user_id, String? user_name) {
    takeName = name;
    agreeCount = agrees;
    disagreeCount = disagrees;
    take_id = id;
    userId = user_id;
    created = date;
    userName = user_name;
  }

  Take.fromJson(Map<String, dynamic> json)
  {
        takeName = json['take'] as String;
        agreeCount = json['agrees'] as int;
        disagreeCount = json['disagrees'] as int;
        take_id = json['take_id'] as int;
        userId = json['author_user_id'] as String;
        created = DateTime.parse(json['created_at']);
        userName = json['user_name'] as String?;
  }
}