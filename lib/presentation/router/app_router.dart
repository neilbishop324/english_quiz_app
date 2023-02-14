import 'package:english_quiz_app/data/repository/sublist_repo.dart';
import 'package:english_quiz_app/logic/sublist/bloc/sublist_bloc.dart';
import 'package:english_quiz_app/presentation/screens/authentication/auth_screen.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/home_screen.dart';
import 'package:english_quiz_app/presentation/screens/sublist/sublist_details_screen.dart';
import 'package:english_quiz_app/presentation/screens/word/word_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case SublistDetailsScreen.routeName:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => const SublistDetailsScreen());
      case WordScreen.routeName:
        return MaterialPageRoute(builder: (_) => const WordScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SizedBox());
    }
  }
}
