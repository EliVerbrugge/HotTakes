import 'package:flutter/material.dart';
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
      String profileName = _user.identities?.elementAt(0).identityData!["full_name"];
      final status, statusText = await Supabase.instance.client.rpc('insert_user_if_not_exists', params: { 'client_user_id': _user.id, 'client_user_name': profileName });
      Navigator.of(context).pushReplacementNamed('Home');
    } else {
      Navigator.of(context).pushReplacementNamed('Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}