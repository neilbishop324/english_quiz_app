import 'package:english_quiz_app/presentation/screens/authentication/auth_screen.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
    }
  }
}
