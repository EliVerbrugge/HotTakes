import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hot_takes/authentication.dart';
import 'package:hot_takes/pages/home_page.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/takes_state.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() async {
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDWWlbJ7-ab-dFBzbAmzrHNy9x7UFK4lyo",
        authDomain: "hottakes-1a324.firebaseapp.com",
        databaseURL: "https://hottakes-1a324.firebaseio.com",
        projectId: "hottakes-1a324",
        storageBucket: "hottakes-1a324.appspot.com",
        messagingSenderId: "807979845276",
        appId: "1:807979845276:web:68cba53455d9a7c381cf59",
      ),
    );
  }
  runApp(HotTakes());
}

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

class AuthExampleApp extends StatelessWidget {
  const AuthExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example App',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraines) {
            return Row(
              children: [
                Visibility(
                  visible: constraines.maxWidth >= 1200,
                  child: Expanded(
                    child: Container(
                      height: double.infinity,
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Firebase Auth Desktop',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: constraines.maxWidth >= 1200
                      ? constraines.maxWidth / 2
                      : constraines.maxWidth,
                  child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return HomePage();
                      }
                      return SignInScreen();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
