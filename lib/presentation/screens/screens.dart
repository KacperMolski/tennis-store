import 'package:flutter/material.dart';
import 'package:tennis_store/presentation/screens/auth/sign_in/sign_in_screen.dart';
import 'package:tennis_store/presentation/screens/auth/sign_up/sign_up_screen.dart';

class Screens {
  static Widget signIn() {
    return SignInScreen(
      emailContoller: TextEditingController(text: ''),
      passwordController: TextEditingController(text: ''),
      measure: const Size(10, 10),
    );
  }

  static Widget signUp() {
    return SignUpScreen(
      controller: TextEditingController(text: ''),
      measure: const Size(10, 10),
    );
  }
}
