import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:flutter/foundation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class ProfilePage extends StatelessWidget {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  User? _user = Supabase.instance.client.auth.currentUser!;
  String profileUrl = "";
  String profileName = "";

  ProfilePage()
  {
    profileUrl = _user?.identities?.elementAt(0).identityData!["picture"];
    profileName = _user?.identities?.elementAt(0).identityData!["full_name"];
  }

  void signOut(BuildContext context) async
  {
    await Supabase.instance.client.auth.signOut();
    Navigator.of(context).pushReplacementNamed('Login');
  }

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    final takeState = Provider.of<TakesState>(context);
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(
          leading: Image.asset("assets/img/take_icon.png"),
          title: Text("Hot Takes"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body:Center(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                profileUrl, // Replace with actual profile image URL
              ),
            ),
            SizedBox(height: 16),
            Text(
              profileName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            FutureBuilder(future: takeState.getUserNumTakes(myUserId), builder: (context, snapshot) {
              List<Widget> children;
              int? numTakes = 0;
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                numTakes = snapshot.data as int?;
                children = <Widget>[
                  ElevatedButton(onPressed: () => signOut(context), child: Text("Sign out")),
                  SizedBox(height: 24),
                  Text("Number of Hot Takes: ${numTakes}", style: TextStyle(fontSize: 15),),
                ];
                } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                    width: 80,
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      'Retrieving Data',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            },),
            SizedBox(height: 24)
          ],
        ),
      )),
    );
  }
}