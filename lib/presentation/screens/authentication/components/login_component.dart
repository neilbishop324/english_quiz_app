import 'package:english_quiz_app/presentation/screens/dashboard/home_screen.dart';
import 'package:english_quiz_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../util/utils.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({super.key});

  @override
  State<LoginComponent> createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(children: [
        eqTextField(controller: _emailController, placeHolder: "Email"),
        eqTextField(controller: _passwordController, placeHolder: "Password"),
        eqButton(text: "Sign In", onPressed: signInUser)
      ]),
    );
  }

  void signInUser() {
    _authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      onSignedIn: () {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);
      },
    );
  }
}
