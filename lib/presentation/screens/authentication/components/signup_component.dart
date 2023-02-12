import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../services/auth_service.dart';
import '../../../util/utils.dart';

class SignUpComponent extends StatefulWidget {
  const SignUpComponent({super.key});

  @override
  State<SignUpComponent> createState() => _SignUpComponentState();
}

class _SignUpComponentState extends State<SignUpComponent> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(children: [
        eqTextField(
            controller: _nameController,
            placeHolder: "Name",
            type: TextInputType.name,
            required: true),
        eqTextField(
            controller: _emailController,
            placeHolder: "Email",
            type: TextInputType.emailAddress,
            required: true),
        eqTextField(
            controller: _passwordController,
            placeHolder: "Password",
            type: TextInputType.visiblePassword,
            required: true),
        eqButton(text: "Sign Up", onPressed: signUpUser)
      ]),
    );
  }

  void signUpUser() {
    _authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text);
  }
}
