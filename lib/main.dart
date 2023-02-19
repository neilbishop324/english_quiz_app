import 'package:english_quiz_app/data/repository/sublist_repo.dart';
import 'package:english_quiz_app/data/repository/word_repo.dart';
import 'package:english_quiz_app/logic/home/cubit/home_cubit.dart';
import 'package:english_quiz_app/logic/quiz/bloc/quiz_bloc.dart';
import 'package:english_quiz_app/logic/sublist/bloc/sublist_bloc.dart';
import 'package:english_quiz_app/logic/user/cubit/user_cubit.dart';
import 'package:english_quiz_app/logic/word/bloc/word_bloc.dart';
import 'package:english_quiz_app/presentation/router/app_router.dart';
import 'package:english_quiz_app/presentation/screens/authentication/auth_screen.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/home_screen.dart';
import 'package:english_quiz_app/services/auth_service.dart';
import 'package:english_quiz_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<UserCubit>(create: (context) => UserCubit()),
      BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
      BlocProvider<SublistBloc>(
          create: (context) => SublistBloc(SublistRepo())),
      BlocProvider<WordBloc>(create: (context) => WordBloc(WordRepo())),
      BlocProvider<QuizBloc>(create: ((context) => QuizBloc())),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  final AppRouter _appRouter = AppRouter();

  @override
  void initState() {
    authService.getUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'English Quiz App',
          theme: ThemeData(
            primaryColorLight: primaryLightColor,
            primaryColorDark: primaryDarkColor,
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: primaryColor, secondary: secondaryColor),
          ),
          onGenerateRoute: _appRouter.onGenerateRoute,
          home: state.user.token.isNotEmpty
              ? const HomeScreen()
              : const AuthScreen(),
        );
      },
    );
  }
}
