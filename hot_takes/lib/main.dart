import 'package:flutter/material.dart';
import 'package:hot_takes/pages/create_take_page.dart';
import 'package:hot_takes/pages/specific_take_page.dart';
import 'package:hot_takes/pages/splash_page.dart';
import 'package:hot_takes/pages/user_takes_page.dart';
import 'package:hot_takes/pages/vote_page.dart';
import 'package:hot_takes/pages/leaderboard_page.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/pages/profile_page.dart';
import 'package:hot_takes/components/takes/takes_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hot_takes/auth/secrets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:go_router/go_router.dart';
import 'nonweb_url_strategy.dart'
    if (dart.library.html) 'web_url_strategy.dart';

import 'pages/select_topic_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _tabNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureUrl();

  await Supabase.initialize(
    url: 'https://psftxdnngksygvzzlkaz.supabase.co',
    anonKey: '$supabaseSecretKey',
  );

  runApp(ChangeNotifierProvider<TakeModel>(
    create: (context) => TakeModel(),
    child: HotTakes(),
  ));
}

class ScaffoldBottomNavigationBar extends StatelessWidget {
  ScaffoldBottomNavigationBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldBottomNavigationBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              icon: Icon(Icons.filter_list_outlined,
                  color: Color.fromRGBO(69, 69, 69, 1)),
              label: 'Topics',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.explore,
                color: Colors.white,
              ),
              icon: Icon(Icons.explore_outlined,
                  color: Color.fromRGBO(69, 69, 69, 1)),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              icon: Icon(
                Icons.add_circle_outline_outlined,
                color: Color.fromRGBO(69, 69, 69, 1),
              ),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                MdiIcons.podium,
                color: Colors.white,
              ),
              icon: Icon(MdiIcons.podium, color: Color.fromRGBO(69, 69, 69, 1)),
              label: 'Top',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              icon: Icon(Icons.person_outlined,
                  color: Color.fromRGBO(69, 69, 69, 1)),
              label: 'Profile',
            ),
          ],
          currentIndex: navigationShell.currentIndex,
          onTap: (int tappedIndex) {
            navigationShell.goBranch(
              tappedIndex,
              initialLocation: tappedIndex == navigationShell.currentIndex,
            );
          }),
    );
  }
}

class HotTakes extends StatefulWidget {
  const HotTakes();

  @override
  State<HotTakes> createState() => _HotTakes();
}

class _HotTakes extends State<HotTakes> {
  bool showBar = false;

  final GoRouter _router = GoRouter(
    initialLocation: '/Splash',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      bool isLoginPage = (state.fullPath == "/Login");
      bool isSplashPage = (state.fullPath == "/Splash");

      if (session == null && !isSplashPage && !isLoginPage) {
        return "/Splash";
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return SplashPage();
        },
      ),
      GoRoute(
        path: '/Splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return SplashPage();
        },
      ),
      GoRoute(
        path: '/Login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return LoginPage();
        },
      ),
      StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) {
            return ScaffoldBottomNavigationBar(
              navigationShell: navigationShell,
            );
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/Personalize',
                  builder: (BuildContext context, GoRouterState state) {
                    return SelectTopicPage();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                    path: '/Explore',
                    builder: (BuildContext context, GoRouterState state) {
                      return VotePage();
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: ':take',
                        builder: (BuildContext context, GoRouterState state) {
                          print("State: ${state.path}");
                          return SpecificTakePage(
                            take_id: int.parse(state.pathParameters["take"]!),
                          );
                        },
                      ),
                    ]),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/CreateTake',
                  builder: (BuildContext context, GoRouterState state) {
                    return CreateTakePage();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/TopTakes',
                  builder: (BuildContext context, GoRouterState state) {
                    return LeaderboardPage();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                    path: '/Profile',
                    builder: (BuildContext context, GoRouterState state) {
                      return ProfilePage();
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'MyTakes',
                        builder: (BuildContext context, GoRouterState state) {
                          return MyTakesPage();
                        },
                      ),
                    ]),
              ],
            ),
          ]),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hot Takes',
      routerConfig: _router,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color.fromRGBO(100, 35, 102, 1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
