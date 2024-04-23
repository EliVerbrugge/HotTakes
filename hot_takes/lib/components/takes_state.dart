import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:synchronized/synchronized.dart';


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

class TakesState extends ChangeNotifier {
  
  // Reference to the database we will be querying for takes
  final databaseReference = Supabase.instance;
  final myUserId = Supabase.instance.client.auth.currentUser!.id;

  final int step = 5;
  static int currentPos = 0;
  
  // A list of current takes in the DB
  List<Take> takes = [];

  // Lock for async code
  final Lock _lock = Lock();

  TakesState()
  {
    fetchTakes(5);
  }

  bool isOutOfCards()
  {
    if(takes.isEmpty)
    {
      fetchTakes(5);
    }
    return takes.isEmpty;
  }

  void fetchTakes(int n) async {
    await _lock.synchronized(() async {
      final data = await databaseReference.client
        .rpc('get_takes_without_votes', params: { 'client_user_id': myUserId})
        .range(currentPos,currentPos+(n-1));

      if(data.length < n)
      {
        n = data.length;
      }

      if(n > 0)
      {
        currentPos+=n;
        for(Map<String, dynamic> obj in data)
        {
          print(obj);
          takes.add(Take.fromJson(obj));
        }
        notifyListeners();
      }
    });
  }

  /// Creates a take with [name] in the remote DB
  void createTake(String name) async {
    await databaseReference.client.from("Takes").insert({'created_at': DateTime.now().toIso8601String(), 'take': name, 'agrees': 0, 'disagrees': 0, 'author_id': myUserId});
    notifyListeners();
  }

  void voted() async {
    takes.removeAt(0);
    print(takes);
    notifyListeners();

    fetchTakes(step);
  }

  String getName(int index)
  {
    if(index < takes.length)
    {
      return takes[index].takeName;
    }
    return "Out of takes";
  }

  String getUserName(int index)
  {
    if(index < takes.length && takes[index].userName != null)
    {
       return takes[index].userName!;
    }
    return "John Doe";
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

  Future<int> getUserNumTakes(String user_id) async
  {
    int numTakes = 0;
    final data = await databaseReference.client.rpc("getnumtakesforuser", params: { 'user_id': myUserId });
    if(data != null)
    {
      numTakes = data as int;
    }
    return numTakes;
  }

  Future<List<Take>> getTopN(int n) async
  {
    List<Take> t = [];
    final data = await databaseReference.client.rpc("get_top_n_takes", params: { 'top_n': n });


    for(Map<String, dynamic> obj in data)
    {
      t.add(Take.fromJson(obj));
    }
    return t;
  }

  Future<List<Take>> getUsersTakes(String user_id) async
  {
    List<Take> t = [];

    final data = await databaseReference.client.rpc("get_user_takes", params: { 'client_user_id': user_id });


    for(Map<String, dynamic> obj in data)
    {
      t.add(Take.fromJson(obj));
    }
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
      await databaseReference.client.from("UserVotes").insert({'user_id': myUserId, 'take_id': t.take_id, 'user_opinion' : 'Agree'});
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
      await databaseReference.client.from("UserVotes").insert({'user_id': myUserId, 'take_id': t.take_id, 'user_opinion' : 'Disagree' });
      await databaseReference.client.rpc("decrementvote", params: { 'row_id': '${t.take_id}' });
    }

  }

  void skip(int index) async {

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
      await databaseReference.client.from("UserVotes").insert({'user_id': myUserId, 'take_id': t.take_id, 'user_opinion' : 'Neutral' });
    }

  }
}
