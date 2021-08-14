import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_takes/authentication.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/takes_state.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() => runApp(HotTakes());

class HotTakes extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HOT TAKES',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: SignInScreen());
  }
}
