import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hot_takes/components/take.dart';
import 'package:hot_takes/components/topic.dart';
import 'package:hot_takes/components/topic_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:synchronized/synchronized.dart';

class TakeModel extends ChangeNotifier {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;
  final myUserId = Supabase.instance.client.auth.currentUser!.id;

  final int defaultStep = 5;
  static int currentPos = 0;
  static int swipeNum = 0;

  bool initialSetupComplete = false;

  // A list of current takes in the DB
  List<Take> takes = [];

  List<Topic> topics = [];
  late Map<String, bool> topic_names;

  // Lock for async code
  final Lock _lock = Lock();

  TakeModel() {
    // Initialize and grab some takes
    setup();
  }

  void setup() async {
    await fetchTopics();
    await fetchTakes(defaultStep);

    // Setup complete, let UI know
    initialSetupComplete = true;
    notifyListeners();
  }

  Future<void> fetchTopics() async {
    topics = await getAllTopics(myUserId);
    topic_names = Map.fromIterable(topics,
        key: (topic) => topic.topic_name, value: (item) => true);
  }

  Map<String, bool> getTopicNames() {
    return topic_names;
  }

  void addTopic(String topic_name) {
    if (topic_names.containsKey(topic_name)) {
      topic_names[topic_name] = true;
      takes.clear();
      swipeNum = 0;
      currentPos = 0;
      fetchTakes(defaultStep);
    }
  }

  void removeTopic(String topic_name) {
    if (topic_names.containsKey(topic_name)) {
      topic_names[topic_name] = false;
      takes.clear();
      swipeNum = 0;
      currentPos = 0;
      fetchTakes(defaultStep);
    }
  }

  bool isOutOfCards() {
    if (takes.isEmpty && initialSetupComplete) {
      currentPos = 0;
      swipeNum = 0;
      fetchTakes(defaultStep);
    }
    return takes.isEmpty;
  }

  Future<void> fetchTakes(int step) async {
    // Aquire lock first, so we don't continously fetch takes on widget rebuilds and such
    await _lock.synchronized(() async {
      // Get takes in the db which the user hasn't voted on
      // utilize range to increment through this list 'step' items at a time
      var data;
      int relativePos = currentPos - swipeNum;
      if (topic_names.isEmpty) {
        try {
          data = await databaseReference.client.rpc('get_takes_without_votes',
              params: {
                'client_user_id': myUserId
              }).range(relativePos, relativePos + (step - 1));
        } catch (e) {
          data = [];
          print(e);
        }
      } else {
        try {
          data = await databaseReference.client
              .rpc('get_takes_in_topics_without_votes', params: {
            'client_user_id': myUserId,
            'topics': topic_names.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList()
          }).range(relativePos, relativePos + (step - 1));
        } catch (e) {
          data = [];
          print(e);
        }
      }

      // If there weren't quite 'step' items left, set it equal to num elements retrieved
      // so we can update current position in results list correctly
      if (data.length < step) {
        step = data.length;
      }

      // If there are elements update our position and add them to the array
      if (step > 0) {
        currentPos += step;
        for (Map<String, dynamic> obj in data) {
          takes.add(Take.fromJson(obj));
        }
        notifyListeners();
      }
    });
  }

  String getName(int index) {
    if (index < takes.length) {
      return takes[index].takeName;
    }
    return "Out of takes";
  }

  String getUserName(int index) {
    if (index < takes.length && takes[index].userName != null) {
      return takes[index].userName!;
    }
    return "John Doe";
  }

  int getAgrees(int index) {
    if (index < takes.length) {
      return takes[index].agreeCount;
    }
    return 0;
  }

  int getDisagrees(int index) {
    if (index < takes.length) {
      return takes[index].disagreeCount;
    }
    return 0;
  }

  int getSpicyness(int index) {
    return takes[index].spicyness;
  }

  bool getIcyOrSpicy(int index) {
    print(takes[index].isIcy);
    return takes[index].isIcy;
  }

  Topic? getTopic(int index) {
    print(takes[index].topic);
    return takes[index].topic;
  }

  void vote(int index, Opinion op) async {
    if (index >= takes.length) {
      return;
    }

    // First check if the user has already voted
    Take t = takes[index];
    final data = await databaseReference.client
        .from('UserVotes')
        .select()
        .filter('user_id', 'eq', myUserId)
        .filter('take_id', 'eq', t.take_id);

    if (data.isEmpty) {
      await databaseReference.client.from("UserVotes").insert(
          {'user_id': myUserId, 'take_id': t.take_id, 'user_opinion': op.name});

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

    // After voting remove the current take
    takes.removeAt(0);
    notifyListeners();
    swipeNum++;

    // Get some more takes
    fetchTakes(defaultStep);
  }
}
