import 'package:english_quiz_app/presentation/screens/authentication/components/login_component.dart';
import 'package:english_quiz_app/presentation/screens/authentication/components/signup_component.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth";

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Login"),
              bottom: const TabBar(tabs: [
                Tab(
                  text: "Sign in",
                ),
                Tab(
                  text: "Sign up",
                )
              ]),
            ),
            body: const TabBarView(
              children: [LoginComponent(), SignUpComponent()],
            )));
  }
}
