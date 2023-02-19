import 'package:english_quiz_app/logic/home/cubit/home_cubit.dart';
import 'package:english_quiz_app/logic/user/cubit/user_cubit.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/components/collection_component.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/components/home_component.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/components/profile_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../data/model/question.dart';
import '../../../logic/quiz/bloc/quiz_bloc.dart';
import '../../../util/utils.dart';
import '../quiz/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<Widget> _widgetOptions = <Widget>[
    HomeComponent(),
    CollectionComponent(),
    ProfileComponent(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(bottomNavBarItems(context)[state.selectedIndex]
                .label
                .toString()),
            actions: [quizButton(state, context)],
          ),
          body: _widgetOptions.elementAt(state.selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavBarItems(context),
            currentIndex: state.selectedIndex,
            onTap: (index) => _onItemTapped(index, context),
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> bottomNavBarItems(BuildContext context) {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favorites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_box),
        label: 'Account',
      ),
    ];
  }

  Widget quizButton(HomeState state, BuildContext context) {
    return Visibility(
      visible: state.selectedIndex == 1,
      child: Align(
        child: InkWell(
          child: const Text(
            "QUIZ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ).paddingSymmetric(horizontal: 25, vertical: 20),
          onTap: () {
            _quiz(context);
          },
        ),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    context.read<HomeCubit>().setSelectedIndex(index);
  }

  void _quiz(BuildContext context) {
    final quizWordList = context.read<UserCubit>().user.favorites;
    createQuestion(quizWordList, context, 1);
    Navigator.pushNamed(context, QuizScreen.routeName,
        arguments: QuizScreenArgs(quizWordList));
  }
}

void createQuestion(List<String> wordList, BuildContext context, int newIndex) {
  if (wordList.length >= 4) {
    final optionWords = pickRandomItemsAsList(wordList, 4);
    final answerWord = pickRandomItemsAsList(optionWords, 1)[0];
    final options = optionWords
        .map((e) => Option(
              word: e,
              title: "",
              index: optionWords.indexOf(e),
              isTrue: e == answerWord,
            ))
        .toList();
    context
        .read<QuizBloc>()
        .add(AddQuestion(options: options, newIndex: newIndex));
  }
}
