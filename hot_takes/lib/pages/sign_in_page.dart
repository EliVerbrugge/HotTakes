import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class LoginPage extends StatefulWidget {
  const LoginPage({key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final TextEditingController _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google, redirectTo: kDebugMode ? 'http://localhost:3000/': 'https://hottakes-1a324.web.app');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logging in!')),
        );
        _emailController.clear();
      }
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        User _user = Supabase.instance.client.auth.currentUser!;
        String profileName = _user.identities?.elementAt(0).identityData!["full_name"];
        final data = Supabase.instance.client.rpc('insert_user_if_not_exists', params: { 'client_user_id': _user.id, 'client_user_name': profileName });
        Navigator.of(context).pushReplacementNamed('Home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: Text("Sign in to Google"),
          ),
        ],
      ),
    );
  }
}