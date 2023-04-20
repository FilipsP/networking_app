import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({super.key});

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  User? _user = Auth().currentUser;

  _isAuth() {
    setState(() {
      _user = Auth().currentUser;
    });
  }

  Future<void> _handleAuthClick() async {
    await Auth().signInAnonymously();
    _isAuth();
  }

  Future<void> _handleSignOutClick() async {
    await Auth().signOut();
    _isAuth();
  }

  Widget userUid() {
    return Text(_user == null ? "Not signed in" : _user?.email ?? "Anonymous");
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
            userUid(),
            contextButton(),
          ],
        ),
      ),
    );
  }
}
