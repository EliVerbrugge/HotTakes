import 'package:flutter/material.dart';
import 'package:hot_takes/pages/splash_page.dart';
import 'package:hot_takes/pages/vote_page.dart';
import 'package:hot_takes/pages/leaderboard_page.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/pages/profile_page.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hot_takes/auth/secrets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://psftxdnngksygvzzlkaz.supabase.co',
    anonKey: '$supabaseSecretKey',
  );

  runApp(ChangeNotifierProvider<TakesState>(
    create: (context) => TakesState(),
    child: HotTakes(),
  ));
}

class HotTakes extends StatefulWidget {
  const HotTakes();

  @override
  State<HotTakes> createState() => _HotTakes();
}

class _HotTakes extends State<HotTakes> {
  int _currentTabIndex = 1;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool showBar = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hot Takes',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      home: Scaffold(
        body: Navigator(
          key: _navigatorKey,
          initialRoute: 'Splash',
          onGenerateRoute: generateRoute,
        ),
        bottomNavigationBar: showBar == true
            ? NavigationBar(
                destinations: [
                  NavigationDestination(
                    selectedIcon: Icon(Icons.person),
                    icon: Icon(Icons.person_outlined),
                    label: 'Profile',
                  ),
                   NavigationDestination(
                    selectedIcon: Icon(Icons.home),
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(MdiIcons.podium),
                    icon: Icon(MdiIcons.podium),
                    label: 'Leaderboard',
                  ),
                ],
                onDestinationSelected: (int index) {
                  switch (index) {
                    case 0:
                      _navigatorKey.currentState
                          ?.pushReplacementNamed("Profile");
                      break;
                    case 1:
                      _navigatorKey.currentState?.pushReplacementNamed("Home");
                      break;
                    case 2:
                      _navigatorKey.currentState
                          ?.pushReplacementNamed("Leaderboard");
                      break;
                  }
                  setState(() {
                    _currentTabIndex = index;
                  });
                },
                indicatorColor: Colors.black,
                selectedIndex: _currentTabIndex,
              )
            : null,
      ),
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "Home":
        setState(() {
          showBar = true;
        });
        return MaterialPageRoute(builder: (context) => VotePage());
      case "Login":
        setState(() {
          showBar = false;
        });
        return MaterialPageRoute(builder: (context) => LoginPage());
      case "Splash":
        return MaterialPageRoute(builder: (context) => SplashPage());
      case "Leaderboard":
        setState(() {
          showBar = true;
        });
        return MaterialPageRoute(builder: (context) => LeaderboardPage());
      case "Profile":
        setState(() {
          showBar = true;
        });
        return MaterialPageRoute(builder: (context) => ProfilePage());
      default:
        setState(() {
          showBar = true;
        });
        return MaterialPageRoute(builder: (context) => VotePage());
    }
  }
}
