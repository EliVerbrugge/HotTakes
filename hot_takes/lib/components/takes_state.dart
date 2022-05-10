import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Take {
  String takeName = "";
  String uniqueID = "";
  int agreeCount = 0;
  int disagreeCount = 0;

  Take(String name, int agrees, int disagrees, String id) {
    takeName = name;
    agreeCount = agrees;
    disagreeCount = disagrees;
    uniqueID = id;
  }
}

class TakesState with ChangeNotifier {
  // Reference to the database we will be querying for takes
  final databaseReference = FirebaseFirestore.instance;
  User? _user = FirebaseAuth.instance.currentUser;

  // A list of current takes in the DB
  List<Take> takes = [];

  TakesState() {
    _listenForUpdates();
  }

  /// Creates a take with [name] in the remote DB
  void createTake(String name) async {
    DocumentReference ref = await databaseReference.collection("takes").add({
      'name': '$name',
      'agreeCount': 0,
      'disagreeCount': 0,
      'users_for': [],
      'users_against': []
    });
  }

  /// Deletes the take with [id] from the DB permanently
  void deleteTake(String id) async {
    DocumentReference ref =
        await databaseReference.collection("takes").doc('$id');
    ref.delete();
  }

  /// Increments the vote tally for take with [id] and current tally [numVotes]
  void agree(String id) async {
    DocumentSnapshot ref =
        await databaseReference.collection("takes").doc('$id').get();
    List<String> users_for = List.from(ref.get('users_for'));
    List<String> users_against = List.from(ref.get('users_against'));

    if (!users_for.contains(_user!.uid) && users_against.contains(_user!.uid)) {
      databaseReference.collection('takes').doc('$id').update({
        'agreeCount': FieldValue.increment(1),
        'disagreeCount': FieldValue.increment(-1),
        'users_for': FieldValue.arrayUnion([_user!.uid]),
        'users_against': FieldValue.arrayRemove([_user!.uid])
      });
    } else if (!users_for.contains(_user!.uid)) {
      databaseReference.collection('takes').doc('$id').update({
        'agreeCount': FieldValue.increment(1),
        'users_for': FieldValue.arrayUnion([_user!.uid])
      });
    } else {
      print("Already voted");
    }
  }

  /// Decrements the vote tally for take with [id] and current tally [numVotes]
  void disagree(String id) async {
    DocumentSnapshot ref =
        await databaseReference.collection("takes").doc('$id').get();
    List<String> users_for = List.from(ref.get('users_for'));
    List<String> users_against = List.from(ref.get('users_against'));

    if (users_for.contains(_user!.uid) && !users_against.contains(_user!.uid)) {
      databaseReference.collection('takes').doc('$id').update({
        'agreeCount': FieldValue.increment(-1),
        'disagreeCount': FieldValue.increment(1),
        'users_for': FieldValue.arrayRemove([_user!.uid]),
        'users_against': FieldValue.arrayUnion([_user!.uid])
      });
    } else if (!users_against.contains(_user!.uid)) {
      databaseReference.collection('takes').doc('$id').update({
        'disagreeCount': FieldValue.increment(1),
        'users_against': FieldValue.arrayUnion([_user!.uid])
      });
    } else {
      print("Already voted");
    }
  }

  /// Listens for updates and triggers update of takes list
  void _listenForUpdates() {
    databaseReference.collection('takes').snapshots().listen((snapshot) {
      if (snapshot.size <= 0) {
        notifyListeners();
        return;
      }

      // First clear the takes
      takes.clear();

      // Now repopulate with all takes from the DB
      snapshot.docs.forEach((element) {
        takes.add(Take(element['name'], element['agreeCount'],
            element['disagreeCount'], element.id));
      });

      // Notify listeners so the widgets can rebuild
      notifyListeners();
    });
  }
}
