import 'package:flutter/material.dart';
import 'package:hot_takes/pages/create_take_page.dart';
import 'package:hot_takes/pages/splash_page.dart';
import 'package:hot_takes/pages/user_takes_page.dart';
import 'package:hot_takes/pages/vote_page.dart';
import 'package:hot_takes/pages/leaderboard_page.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/pages/profile_page.dart';
import 'package:hot_takes/components/takes_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hot_takes/auth/secrets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'pages/select_topic_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://psftxdnngksygvzzlkaz.supabase.co',
    anonKey: '$supabaseSecretKey',
  );

  runApp(ChangeNotifierProvider<TakeModel>(
    create: (context) => TakeModel(),
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
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                    icon: Icon(Icons.filter_list_outlined,
                        color: Color.fromRGBO(69, 69, 69, 1)),
                    label: 'Pesonalize',
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
                      _navigatorKey.currentState
                          ?.pushReplacementNamed("Select Topics");
                      break;
                    case 1:
                      _navigatorKey.currentState?.pushReplacementNamed("Home");
                      break;
                    case 2:
                      _navigatorKey.currentState
                          ?.pushReplacementNamed("Create Take");
                      break;
                    case 3:
                      _navigatorKey.currentState
                          ?.pushReplacementNamed("Leaderboard");
                      break;
                    case 4:
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
      case "My Takes":
        setState(() {
          showBar = true;
        });
        return MaterialPageRoute(builder: (context) => MyTakesPage());
      case "Create Take":
        setState(() {
          showBar = true;
        });
        return MaterialPageRoute(builder: (context) => CreateTakePage());
      case "Select Topics":
        setState(() {
          showBar = true;
        });
        return MaterialPageRoute(builder: (context) => SelectTopicPage());
      default:
        setState(() {
          showBar = true;
        });
        return MaterialPageRoute(builder: (context) => VotePage());
    }
  }
}
