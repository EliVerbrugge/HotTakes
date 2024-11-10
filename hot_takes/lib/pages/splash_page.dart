import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage();

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      User _user = Supabase.instance.client.auth.currentUser!;
      String profileName =
          _user.identities?.elementAt(0).identityData!["full_name"];
      await Supabase.instance.client.rpc('insert_user_if_not_exists', params: {
        'client_user_id': _user.id,
        'client_user_name': profileName
      });
      String profileUrl =
          _user?.identities?.elementAt(0).identityData!["picture"];

      precacheImage(NetworkImage(profileUrl), context);
      context.go("/Explore");
    } else {
      context.go("/Intro");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
