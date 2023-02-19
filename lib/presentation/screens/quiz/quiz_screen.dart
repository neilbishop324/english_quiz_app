import 'package:english_quiz_app/data/model/question.dart';
import 'package:english_quiz_app/logic/quiz/bloc/quiz_bloc.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/home_screen.dart';
import 'package:english_quiz_app/presentation/util/utils.dart';
import 'package:english_quiz_app/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../error/components/error_component.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  static const String routeName = "/quiz";

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class QuizScreenArgs {
  final List<String> wordList;

  QuizScreenArgs(this.wordList);
}

class _QuizScreenState extends State<QuizScreen> {
  List<String> wordList = [];
  int _trueWord = 0;
  int _questionSize = 10;

  @override
  Widget build(BuildContext context) {
    wordList =
        (ModalRoute.of(context)!.settings.arguments as QuizScreenArgs).wordList;
    if (wordList.length < 13) {
      if (wordList.length > 3) {
        _questionSize = wordList.length - 3;
      } else {}
    }
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Quiz"),
            actions: (state is QuizLoaded)
                ? [
                    Text(
                      "${state.questionIndex}/$_questionSize",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ).paddingAll(20),
                  ]
                : [],
          ),
          body: questionComponent(state),
        );
      },
    );
  }

  Widget questionComponent(QuizState state) {
    if (state is QuizLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is QuizError) {
      return ErrorComponent(errorContent: state.error);
    } else if (state is QuizLoaded) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            questionHeader(state.question.word),
            answer(state.question.option1, state),
            answer(state.question.option2, state),
            answer(state.question.option3, state),
            answer(state.question.option4, state),
          ],
        ),
      );
    } else if (state is QuizFinished) {
      return quizFinished(state);
    } else {
      return const SizedBox();
    }
  }

  Widget questionHeader(String word) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width - 40,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: indigo,
      ),
      child: Text(
        word,
        style: const TextStyle(
          color: white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ).paddingAll(20),
    ).paddingAll(20);
  }

  Widget answer(Option option, QuizLoaded state) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width - 40,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: lightCoral,
      ),
      child: InkWell(
        onTap: () => answerOnClick(context, option, state),
        child: Text(
          "${getOption(option)}-) ${option.title}",
          style: const TextStyle(
            color: white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ).paddingAll(10),
      ),
    ).paddingSymmetric(vertical: 5, horizontal: 20);
  }

  void answerOnClick(BuildContext context, Option option, QuizLoaded state) {
    //Showing snackbar
    final options = [
      state.question.option1,
      state.question.option2,
      state.question.option3,
      state.question.option4
    ];

    final trueAnswer =
        getOption(options.firstWhere((element) => element.isTrue));

    showSnackBar(context,
        (option.isTrue) ? "Correct!" : "Incorrect! It was $trueAnswer");

    //Changing result
    if (option.isTrue) {
      _trueWord++;
    }

    if (state.questionIndex == _questionSize) {
      showSnackBar(context,
          "Quiz is over! $_trueWord right, ${_questionSize - _trueWord} wrong");
      context.read<QuizBloc>().add(QuizFinishedEvent(
          trueWord: _trueWord, falseWord: _questionSize - _trueWord));
    }

    context.read<QuizBloc>().add(ChangeQuestionIndex(_questionSize));

    wordList.remove(option.word);

    if (state.questionIndex <= _questionSize &&
        context.read<QuizBloc>().state is QuizLoaded) {
      final quizState = context.read<QuizBloc>().state as QuizLoaded;
      createQuestion(wordList, context, quizState.questionIndex);
    }
  }

  Widget quizFinished(QuizFinished state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width - 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: greenColor,
            ),
            child: Text(
              "${state.trueSize} right",
              style: const TextStyle(
                color: white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ).paddingAll(10),
          ).paddingSymmetric(horizontal: 20).paddingTop(20),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width - 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: redColor,
            ),
            child: Text(
              "${state.falseSize} wrong",
              style: const TextStyle(
                color: white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ).paddingAll(10),
          ).paddingSymmetric(horizontal: 20).paddingTop(20),
        ],
      ),
    );
  }

  String getOption(Option option) {
    switch (option.index) {
      case 0:
        return "A";
      case 1:
        return "B";
      case 2:
        return "C";
      default:
        return "D";
    }
  }
}
