import 'package:hot_takes/components/topics/topic.dart';
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

Future<Take?> getTake(String user_id, int take_id) async {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;

  Take? t = null;

  final data = await databaseReference.client.rpc("get_take_if_without_votes",
      params: {'client_user_id': user_id, 'this_take_id': take_id});

  for (Map<String, dynamic> obj in data) {
    t = Take.fromJson(obj);
  }
  return t;
}

void vote(Take t, String user_id, Opinion op) async {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;
  await databaseReference.client.from("UserVotes").insert(
      {'user_id': user_id, 'take_id': t.take_id, 'user_opinion': op.name});

  switch (op) {
    case Opinion.Disagree:
      await databaseReference.client
          .rpc("decrementvote", params: {'row_id': '${t.take_id}'});
      break;
    case Opinion.Agree:
      await databaseReference.client
          .rpc("incrementvote", params: {'row_id': '${t.take_id}'});
      break;
    case Opinion.Neutral:
      break;
  }
}
