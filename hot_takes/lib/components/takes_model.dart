import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hot_takes/components/take.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:synchronized/synchronized.dart';

class TakeModel extends ChangeNotifier {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;
  final myUserId = Supabase.instance.client.auth.currentUser!.id;

  final int step = 5;
  static int currentPos = 0;

  // A list of current takes in the DB
  List<Take> takes = [];

  // Lock for async code
  final Lock _lock = Lock();

  TakesState() {
    // Initialize and grab some takes
    fetchTakes(5);
  }

  bool isOutOfCards() {
    // If empty, let's try and fetch some more (never a reason to show empty)
    if (takes.isEmpty) {
      fetchTakes(5);
    }
    return takes.isEmpty;
  }

  void fetchTakes(int step) async {
    // Aquire lock first, so we don't continously fetch takes on widget rebuilds and such
    await _lock.synchronized(() async {
      // Get takes in the db which the user hasn't voted on
      // utilize range to increment through this list n at a time
      final data = await databaseReference.client.rpc('get_takes_without_votes',
          params: {
            'client_user_id': myUserId
          }).range(currentPos, currentPos + (step - 1));

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

    // Get some more takes
    fetchTakes(step);
  }
}
