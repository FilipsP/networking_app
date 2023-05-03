import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import 'sign_in_register.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({super.key});

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  User? _user = Auth().currentUser;
  String? _errorMessage;

  _isAuth() {
    setState(() {
      _user = Auth().currentUser;
    });
  }

  Future<void> _handleAuthClick() async {
    try {
      await Auth().signInAnonymously();
      _isAuth();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _handleSignOutClick() async {
    if (_user?.isAnonymous ?? true) {
      await _user?.delete();
    } else {
      await Auth().signOut();
    }
    _isAuth();
  }

  Widget _userUid() {
    return Text(_user == null ? "Not signed in" : _user?.email ?? "Guest");
  }

  Widget _errorMessageWidget() {
    return Text(_errorMessage ?? "", style: const TextStyle(color: Colors.red));
  }

  Widget _contextButtonContent() {
    return ElevatedButton(
      onPressed: _user != null ? _handleSignOutClick : _handleAuthClick,
      child: Text(_user != null ? "Sign Out" : "Sign in guest"),
    );
  }

  Widget _contextButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _contextButtonContent(),
        ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignInRegister(),
            ),
          ),
          child: const Text("Sign in/Register"),
        ),
      ],
    );
  }

  Widget _contextButtonsContainer() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300.0,
        minWidth: 200.0,
        minHeight: 180.0,
      ),
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
        color: Colors.white60,
        border: Border.fromBorderSide(
          BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: _contextButtons(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userUid(),
            _contextButtonsContainer(),
            _errorMessageWidget(),
          ],
        ),
      ),
    );
  }
}
