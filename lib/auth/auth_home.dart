import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

class AuthHome extends StatefulWidget {
  AuthHome({super.key});

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  final User? _user = Auth().currentUser;

  Future<void> _handleAuthClick() async {
    await Auth().signInAnonymously();
  }

  Future<void> _handleSignOutClick() async {
    await Auth().signOut();
  }

  Widget userUid() {
    return Text(_user?.email ?? "No email");
  }

  Widget contextButton() {
    return ElevatedButton(
      onPressed: _user != null ? _handleSignOutClick : _handleAuthClick,
      child: Text(_user != null ? "Sign Out" : "Sign In"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null) userUid(),
            contextButton(),
          ],
        ),
      ),
    );
  }
}
