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
        primaryColor: Color.fromRGBO(100, 35, 102, 1),
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
                    selectedIcon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    icon: Icon(Icons.home_outlined,
                        color: Color.fromRGBO(69, 69, 69, 1)),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.explore,
                      color: Colors.white,
                    ),
                    icon: Icon(Icons.explore_outlined,
                        color: Color.fromRGBO(69, 69, 69, 1)),
                    label: 'Explore',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                    icon: Icon(
                      Icons.add_circle_outline_outlined,
                      color: Color.fromRGBO(69, 69, 69, 1),
                    ),
                    label: 'Create Take',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      MdiIcons.podium,
                      color: Colors.white,
                    ),
                    icon: Icon(MdiIcons.podium,
                        color: Color.fromRGBO(69, 69, 69, 1)),
                    label: 'Top Takes',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    icon: Icon(Icons.person_outlined,
                        color: Color.fromRGBO(69, 69, 69, 1)),
                    label: 'Profile',
                  ),
                ],
                onDestinationSelected: (int index) {
                  switch (index) {
                    case 0:
                      _navigatorKey.currentState?.pushReplacementNamed("Home");
                      break;
                    case 1:
                      _navigatorKey.currentState
                          ?.pushReplacementNamed("Leaderboard");
                      break;
                    case 2:
                      _navigatorKey.currentState
                          ?.pushReplacementNamed("Leaderboard");
                      break;
                    case 3:
                      _navigatorKey.currentState
                          ?.pushReplacementNamed("Profile");
                      break;
                  }
                  setState(() {
                    _currentTabIndex = index;
                  });
                },
                backgroundColor: Colors.black,
                indicatorColor: Color.fromRGBO(0, 0, 0, 0),
                selectedIndex: _currentTabIndex,
              )
            : null,
      ),
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "Home":
      case "/home":
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
