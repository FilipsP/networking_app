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
  String _errorMessage = "";
  //used to toggle between sign in and register
  String pageState = 'sign in';
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
      _errorMessage = "";
    });
  }

  _setTitle() {
    setState(() {
      if (pageState == 'sign in') {
        _title = 'Sign In';
      }
      if (pageState == 'register') {
        _title = 'Register';
      }
      if (pageState == 'reset password') {
        _title = 'Reset Password';
      }
    });
  }

  _leaveSignInRegister() {
    Navigator.pop(context);
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (!_isEmailValid || !_isPasswordValid) {
      return;
    }
    try {
      await Auth()
          .handleSignIn(
            email: _emailController.text,
            password: _passwordController.text,
          )
          .then((value) => _leaveSignInRegister());
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
        pageState = 'sign in';
      });
      _setTitle();
      _resetErrorMessage();
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_isEmailValid) {
      return;
    }
    try {
      await Auth().sendPasswordResetEmail(email: _emailController.text);
      setState(() {
        pageState = 'sign in';
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

  void _handleSubmitButtonClick() {
    if (pageState == 'sign in') {
      _signInWithEmailAndPassword();
    }
    if (pageState == 'register') {
      _createUserWithEmailAndPassword();
    }
    if (pageState == 'reset password') {
      _sendPasswordResetEmail();
    }
  }

  void _setPageState(String state) {
    setState(() {
      pageState = state;
    });
  }

  bool _isPasswordEntryFieldEnabled() {
    return pageState == 'sign in' || pageState == 'register';
  }

  Widget _passwordEntryField() {
    return TextFormField(
      onChanged: (value) {
        if (_errorMessage != "") {
          _resetErrorMessage();
        }
        if (!_isTextObscured) {
          setState(() {
            _isTextObscured = true;
          });
        }
      },
      enabled: _isPasswordEntryFieldEnabled(),
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
    return Text(_errorMessage, style: TextStyle(color: Colors.red[900]));
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: _handleSubmitButtonClick,
      child: Text(_title),
    );
  }

  Widget _passwordLostPrompt() {
    if (pageState == 'reset password' || pageState == 'register') {
      return const SizedBox.shrink();
    }
    return TextButton(
      child: const Text("Forgot password?"),
      onPressed: () => setState(() {
        pageState = 'reset password';
        _passwordController.clear();
        _setTitle();
        _resetErrorMessage();
      }),
    );
  }

  Widget _pageSwitchTextButton() {
    return TextButton(
      onPressed: () {
        if (pageState == 'sign in') {
          _setPageState('register');
        } else {
          _setPageState('sign in');
        }
        _setTitle();
        _resetErrorMessage();
      },
      child: Text(
        pageState == 'sign in'
            ? 'Don\'t have an account? Register'
            : 'Already have an account? Sign in',
      ),
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
            _passwordLostPrompt(),
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
