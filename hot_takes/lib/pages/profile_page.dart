import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/takes/take_utils.dart';

class ProfilePage extends StatelessWidget {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  User? _user = Supabase.instance.client.auth.currentUser!;
  String profileUrl = "";
  String profileName = "";

  ProfilePage() {
    profileUrl = _user?.identities?.elementAt(0).identityData!["picture"];
    profileName = _user?.identities?.elementAt(0).identityData!["full_name"];
  }

  void signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    context.go("/Login");
  }

  void getTakePage(BuildContext context) async {
    context.go("/Profile/MyTakes");
  }

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        //leading: Image.asset("assets/img/take_icon.png"),
        title: Text("Hot Takes"),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
            color: Color.fromRGBO(175, 0, 123, 1),
            fontWeight: FontWeight.bold,
            fontSize: 25),
      ),
      body: Center(
          child: Padding(
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
            ElevatedButton(
                onPressed: () => signOut(context), child: Text("Sign out")),
            SizedBox(height: 24),
            ElevatedButton(
                onPressed: () => getTakePage(context),
                child: Text("See my takes")),
            SizedBox(height: 24),
            FutureBuilder(
              future: getUserNumTakes(myUserId),
              builder: (context, snapshot) {
                List<Widget> children;
                int? numTakes = 0;
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  numTakes = snapshot.data;
                  children = <Widget>[
                    Text(
                      "Number of Hot Takes: ${numTakes}",
                      style: TextStyle(fontSize: 15),
                    ),
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
                    Text(
                      'Retrieving Data',
                      style: TextStyle(fontSize: 15),
                    ),
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
