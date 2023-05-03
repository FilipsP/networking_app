import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class SignInRegister extends StatefulWidget {
  const SignInRegister({super.key});

  @override
  SignInRegisterState createState() => SignInRegisterState();
}

class SignInRegisterState extends State<SignInRegister> {
  String _title = "Sign In";
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  String? _errorMessage;
  //used to toggle between sign in and register
  bool _isSignInPage = false;
  bool _isTextObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _handleFirebaseError(e) {
    setState(() {
      if (e.code == 'weak-password') {
        _errorMessage = 'The password is too weak';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = 'The account already exists for that email';
      } else if (e.code == 'user-not-found') {
        _errorMessage = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Wrong password';
      } else {
        _errorMessage = e.message;
      }
      if (kDebugMode) {
        print(e);
      }
    });
  }

  _resetErrorMessage() {
    setState(() {
      _errorMessage = null;
    });
  }

  _setTitle() {
    setState(() {
      _title = _isSignInPage ? "Sign In" : "Register";
    });
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (!_isEmailValid || !_isPasswordValid) {
      return;
    }
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    if (!_isEmailValid || !_isPasswordValid) {
      return;
    }
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _isSignInPage = true;
      });
      _setTitle();
      _resetErrorMessage();
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    }
  }

  Widget _emailEntryField() {
    return TextFormField(
      controller: _emailController,
      validator: _emailValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
    );
  }

  String? _emailValidator(value) {
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (_isEmailValid) {
      _isEmailValid = false;
    }
    if (value.isEmpty) {
      return 'Please enter an email address';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    _isEmailValid = true;
    return null;
  }

  String? _passwordValidator(value) {
    if (_isPasswordValid) {
      _isPasswordValid = false;
    }
    if (value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    _isPasswordValid = true;
    return null;
  }

  Widget _passwordEntryField() {
    return TextFormField(
      onChanged: (value) {
        if (_errorMessage != null) {
          _resetErrorMessage();
        }
        if (!_isTextObscured) {
          setState(() {
            _isTextObscured = true;
          });
        }
      },
      controller: _passwordController,
      obscureText: _isTextObscured,
      validator: _passwordValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isTextObscured ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isTextObscured = !_isTextObscured;
            });
          },
        ),
      ),
    );
  }

  Widget _errorMessageWidget() {
    return Text(_errorMessage ?? "", style: TextStyle(color: Colors.red[900]));
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: _isSignInPage
          ? _signInWithEmailAndPassword
          : _createUserWithEmailAndPassword,
      child: Text(_isSignInPage ? "Sign in" : "Register"),
    );
  }

  Widget _pageSwitchTextButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isSignInPage = !_isSignInPage;
        });
        _setTitle();
        _resetErrorMessage();
      },
      child: Text(_isSignInPage
          ? "Don't have an account? Register"
          : "Already have an account? Sign in"),
    );
  }

  Widget _buildFormContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(children: [
            _emailEntryField(),
            const SizedBox(height: 10),
            _passwordEntryField(),
            const SizedBox(height: 10),
            _errorMessageWidget(),
            _submitButton(),
            const SizedBox(height: 10),
            _pageSwitchTextButton(),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title), centerTitle: true),
      body: Center(child: _buildFormContainer()),
    );
  }
}
