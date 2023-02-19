import 'package:english_quiz_app/presentation/screens/dashboard/home_screen.dart';
import 'package:english_quiz_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../util/constants.dart';

class LoginComponent extends StatelessWidget {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          16.height,
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          16.height,
          ElevatedButton(
            onPressed: () => signInUser(context),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 18,
              ),
            ),
            child: const Text('LOGIN'),
          ),
        ],
      ),
    );
  }

  void signInUser(BuildContext context) {
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
