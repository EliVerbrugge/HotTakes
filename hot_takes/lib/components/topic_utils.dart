import 'package:supabase_flutter/supabase_flutter.dart';

import 'topic.dart';

Future<List<Topic>> getAllTopics(String user_id) async {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;

  List<Topic> t = [];

  final data = await databaseReference.client
      .rpc("get_user_available_topics", params: {'client_user_id': user_id});

  for (Map<String, dynamic> obj in data) {
    t.add(Topic.fromJson(obj));
  }
  print(t);

  return t;
}
