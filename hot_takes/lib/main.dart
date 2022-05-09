import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hot_takes/components/authentication.dart';
import 'package:hot_takes/pages/home_page.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Hot Takes',
      theme: ThemeData(primaryColor: Colors.red),
      key: UniqueKey(),
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hot Takes Desktop',
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
                      if (snapshot.hasData && snapshot.data != null) {
                        return ChangeNotifierProvider<TakesState>(
                          create: (context) => TakesState(),
                          child: HomePage(),
                        );
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
