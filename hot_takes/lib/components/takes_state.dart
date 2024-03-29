import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class Take {
  int take_id = 0;
  int agreeCount = 0;
  int disagreeCount = 0;
  DateTime created = DateTime.fromMicrosecondsSinceEpoch(0);
  String takeName = "";
  String userId = "";


  Take(String name, int agrees, int disagrees, int id, DateTime date, String user_id) {
    takeName = name;
    agreeCount = agrees;
    disagreeCount = disagrees;
    take_id = id;
    userId = user_id;
    created = date;
  }

  Take.fromJson(Map<String, dynamic> json)
  {
        takeName = json['take'] as String;
        agreeCount = json['agrees'] as int;
        disagreeCount = json['disagrees'] as int;
        take_id = json['take_id'] as int;
        userId = json['author_id'] as String;
        created = DateTime.parse(json['created_at']);
  }
}

class TakesState extends ChangeNotifier {
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  final int step = 5;
  static int currentPos = 0;
  int currentIndex = 0;
  bool gettingCards = false;
  // A list of current takes in the DB
  List<Take> takes = [];

  TakesState() {
    fetchTakes();
  }

  bool outOfCards()
  {
    if(takes.isEmpty && !gettingCards)
    {
      fetchTakes();
    }
    return takes.isEmpty;
  }

  List<int> getPagination(int page, int size)
  {
    int from = page * size;
    int to = from + size;

    return [from, to];
  }

  void fetchTakes() async {
    gettingCards = true;
    List<int> pagination = getPagination(currentPos, step);
    final data = await databaseReference.client
      .from('Takes')
      .select()
      .order("take_id", ascending: true)
      .range(pagination[0],pagination[1]);

    currentPos++;
    for(Map<String, dynamic> obj in data)
    {
      takes.add(Take.fromJson(obj));
    }
    notifyListeners();
    gettingCards = false;
  }

  /// Creates a take with [name] in the remote DB
  void createTake(String name) async {
    await databaseReference.client.from("Takes").insert({'created_at': DateTime.now().toIso8601String(), 'take': name, 'agrees': 0, 'disagrees': 0, 'author_id': myUserId});
    notifyListeners();
  }

  void loadAhead() async {
    gettingCards = true;
    takes.removeAt(0);
    notifyListeners();
        
    List<int> pagination = getPagination(currentPos, step);
    final data = await databaseReference.client
      .from('Takes')
      .select()
      .order("take_id", ascending: true)
      .range(pagination[0],pagination[1]);

    currentPos++;
    
    for(Map<String, dynamic> obj in data)
    {
      takes.add(Take.fromJson(obj));
    }
    gettingCards = false;
  }

  String getName(int index)
  {
    if(index < takes.length)
    {
      return takes[index].takeName;
    }
    return "Out of takes";
  }

  int getAgrees(int index)
  {
    if(index < takes.length)
    {
      return takes[index].agreeCount;
    }
    return 0;
  }


  int getDisagrees(int index)
  {
    if(index < takes.length)
    { 
      return takes[index].disagreeCount;
    }
    return 0;
  }

  Future<List<Take>> getTop5() async
  {
    List<Take> t = [];
    final data = await databaseReference.client
    .from('Takes')
    .select()
    .order('agrees')
    .limit(5);

    for(Map<String, dynamic> obj in data)
    {
      t.add(Take.fromJson(obj));
    }
    print("Random sampling: ${t.first.takeName}");
    return t;
  }

  void agree(int index) async {

    if(index >= takes.length)
    {
      return;
    }
    Take t = takes[index];
    final data = await databaseReference.client
    .from('UserVotes')
    .select()
    .filter('user_id', 'eq', myUserId)
    .filter('take_id', 'eq', t.take_id);

    if(data.isEmpty)
    {
      await databaseReference.client.from("UserVotes").insert({'created_at': DateTime.now().toIso8601String(), 'user_id': myUserId, 'take_id': t.take_id,'is_agreement': true});
      await databaseReference.client.rpc("incrementvote", params: { 'row_id': '${t.take_id}' });
    }

  }

  void disagree(int index) async {

    if(index >= takes.length)
    {
      return;
    }

    Take t = takes[index];
    final data = await databaseReference.client
    .from('UserVotes')
    .select()
    .filter('user_id', 'eq', myUserId)
    .filter('take_id', 'eq', t.take_id);

    if(data.isEmpty)
    {
      await databaseReference.client.from("UserVotes").insert({'created_at': DateTime.now().toIso8601String(), 'user_id': myUserId, 'take_id': t.take_id,'is_agreement': false});
      await databaseReference.client.rpc("decrementvote", params: { 'row_id': '${t.take_id}' });
    }

  }
}
