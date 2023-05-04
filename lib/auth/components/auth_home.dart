import 'dart:async';

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
  final User? _user = Auth().currentUser;
  String _errorMessage = "";

  Future<void> _handleAuthClick() async {
    try {
      await Auth().signInAnonymously();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _handleSignOutClick() async {
    await Auth().signOut();
  }

  Widget _userUid() {
    return Text(_user == null ? "Not signed in" : _user?.email ?? "Guest");
  }

  Widget _errorMessageWidget() {
    return Text(_errorMessage, style: const TextStyle(color: Colors.red));
  }

  Widget _contextButtonContent() {
    return ElevatedButton(
      onPressed: _user != null ? _handleSignOutClick : _handleAuthClick,
      child: Text(_user != null ? "Sign Out" : "Sign in guest"),
    );
  }

  Widget _signInRegisterButton() {
    if (_user?.email != null) {
      return const SizedBox.shrink();
    }
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInRegister()),
        );
      },
      child: const Text("Sign In/Register"),
    );
  }

  Widget _contextButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _contextButtonContent(),
        _signInRegisterButton(),
      ],
    );
  }

  Widget _contextButtonsContainer() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300.0,
        minWidth: 200.0,
      ),
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: _contextButtons(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userUid(),
          _contextButtonsContainer(),
          _errorMessageWidget(),
        ],
      ),
    );
  }
}
