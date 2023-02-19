import 'package:english_quiz_app/data/model/question.dart';
import 'package:english_quiz_app/logic/quiz/bloc/quiz_bloc.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/home_screen.dart';
import 'package:english_quiz_app/presentation/screens/quiz/components/quiz_finished_component.dart';
import 'package:english_quiz_app/presentation/util/utils.dart';
import 'package:english_quiz_app/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<String> mWordList = [];
  int _correctAnswers = 0;
  int _questionSize = 10;

  @override
  Widget build(BuildContext context) {
    mWordList =
        (ModalRoute.of(context)!.settings.arguments as QuizScreenArgs).wordList;
    wordList = List.from(mWordList);
    if (mWordList.length < 13) {
      if (mWordList.length > 3) {
        _questionSize = mWordList.length - 3;
      }
    }

    final backgroundColor = Theme.of(context).colorScheme.onBackground;

    // Set the status bar and system navigation bar colors to match the background color of the app
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        systemNavigationBarColor: backgroundColor,
        statusBarBrightness: Theme.of(context).brightness,
      ),
    );

    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            shadowColor: Colors.transparent,
            leading: IconButton(
                color: black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close)),
            title: LinearProgressIndicator(
              minHeight: 15,
              value: (state is QuizLoaded)
                  ? state.questionIndex / _questionSize
                  : 1 / 10,
            ).cornerRadiusWithClipRRect(20).paddingOnly(left: 10, right: 30),
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
      return loadedComponent(state);
    } else if (state is QuizFinished) {
      return QuizFinishedComponent(
          allWordList: wordList, context: context, state: state);
    } else {
      return const SizedBox();
    }
  }

  Widget loadedComponent(QuizLoaded state) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Meaning of ${state.question.word}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              32.height,
              optionButton(state.question.option1, state),
              16.height,
              optionButton(state.question.option2, state),
              16.height,
              optionButton(state.question.option3, state),
              16.height,
              optionButton(state.question.option4, state),
            ],
          )),
    );
  }

  Widget optionButton(Option option, QuizLoaded state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            width: 2,
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Text(
                getOption(option),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).paddingAll(10),
          16.height,
          Expanded(
            child: Text(
              option.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onPressed: () => answerOnClick(context, option, state),
    );
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
      _correctAnswers++;
    }

    if (state.questionIndex == _questionSize) {
      showSnackBar(context,
          "Quiz is over! $_correctAnswers right, ${_questionSize - _correctAnswers} wrong");
      context.read<QuizBloc>().add(QuizFinishedEvent(
          trueWord: _correctAnswers,
          falseWord: _questionSize - _correctAnswers));
    }

    context.read<QuizBloc>().add(ChangeQuestionIndex(_questionSize));

    mWordList.remove(option.word);

    if (state.questionIndex <= _questionSize &&
        context.read<QuizBloc>().state is QuizLoaded) {
      final quizState = context.read<QuizBloc>().state as QuizLoaded;
      createQuestion(mWordList, context, quizState.questionIndex);
    }
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
