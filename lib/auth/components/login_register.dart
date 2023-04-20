import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  LoginRegisterState createState() => LoginRegisterState();
}

class LoginRegisterState extends State<LoginRegister> {
  String? _errorMessage;
  final bool _isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: title,
      ),
    );
  }

  Widget _errorMessageWidget() {
    return Text(_errorMessage ?? "");
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: _isLogin
          ? _signInWithEmailAndPassword
          : _createUserWithEmailAndPassword,
      child: Text(_isLogin ? "Login" : "Register"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField("Email", _emailController),
            _entryField("Password", _passwordController),
            _errorMessageWidget(),
            _submitButton(),
          ],
        ),
      ),
    );
  }
}
