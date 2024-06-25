import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (kIsWeb) {
        await Supabase.instance.client.auth.signInWithOAuth(
            OAuthProvider.google,
            redirectTo: kDebugMode
                ? 'http://localhost:3000/'
                : 'https://hottakes-1a324.web.app');
      } else if (Platform.isAndroid) {
        const webClientId =
            '807979845276-4b0fhfpr2l4644j2ba66sd30psp8safl.apps.googleusercontent.com';

        const androidClientId =
            '807979845276-n6k7v69t2i4o3osvrbtedf3qdt8b77hm.apps.googleusercontent.com';

        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: androidClientId,
          serverClientId: webClientId,
        );
        final googleUser = await googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;

        if (accessToken == null) {
          throw 'No Access Token found.';
        }
        if (idToken == null) {
          throw 'No ID Token found.';
        }

        await Supabase.instance.client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logging in!')),
        );
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
    _authStateSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;

      if (_redirecting) return;
      if (session != null) {
        _redirecting = true;
        User _user = Supabase.instance.client.auth.currentUser!;
        String profileName =
            _user.identities?.elementAt(0).identityData!["full_name"];
        Supabase.instance.client.rpc('insert_user_if_not_exists', params: {
          'client_user_id': _user.id,
          'client_user_name': profileName
        });
        context.go("/Explore");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
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
