import 'package:hot_takes/components/topic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'take.dart';

/// Creates a take with [name] in the remote DB
void createTake(String name, Topic topic) async {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;
  final myUserId = Supabase.instance.client.auth.currentUser!.id;

  final data = await databaseReference.client.from("Takes").insert({
    'take': name,
    'agrees': 0,
    'disagrees': 0,
    'author_id': myUserId,
    'topic_id': topic.topic_id
  }).select();
  print(data);
}

Future<int> getUserNumTakes(String user_id) async {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;
  final myUserId = Supabase.instance.client.auth.currentUser!.id;

  int numTakes = 0;

  final data = await databaseReference.client
      .rpc("getnumtakesforuser", params: {'user_id': myUserId});

  if (data != null) {
    numTakes = data as int;
  }
  return numTakes;
}

Future<List<Take>> getTopNTakes(int n) async {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;

  List<Take> t = [];

  final data = await databaseReference.client
      .rpc("get_top_n_takes", params: {'top_n': n});

  for (Map<String, dynamic> obj in data) {
    t.add(Take.fromJson(obj));
  }
  return t;
}

Future<List<Take>> getUsersTakes(String user_id) async {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;

  List<Take> t = [];

  final data = await databaseReference.client
      .rpc("get_user_takes", params: {'client_user_id': user_id});

  for (Map<String, dynamic> obj in data) {
    t.add(Take.fromJson(obj));
  }
  return t;
}
