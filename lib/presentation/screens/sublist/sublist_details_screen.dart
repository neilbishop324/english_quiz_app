import 'package:english_quiz_app/presentation/screens/error/components/error_component.dart';
import 'package:english_quiz_app/presentation/util/utils.dart';
import 'package:english_quiz_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/sublist/bloc/sublist_bloc.dart';
import '../dashboard/home_screen.dart';
import '../quiz/quiz_screen.dart';

class SublistDetailsScreen extends StatefulWidget {
  const SublistDetailsScreen({super.key});

  static const String routeName = "/sublist_details";

  @override
  State<SublistDetailsScreen> createState() => _SublistDetailsScreenState();
}

class _SublistDetailsScreenState extends State<SublistDetailsScreen> {
  var pageNumber = 1;

  @override
  void initState() {
    pageNumber = context.read<SublistBloc>().pageNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SublistDetailsArguments;
    bool fromWordsAndPhrases = (args.listId == wordsAndPhrases);
    final title = fromWordsAndPhrases
        ? "Words And Phrases"
        : "Sublist ${args.listId + 1}";
    return BlocConsumer<SublistBloc, SublistState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                if (state is SublistLoaded) {
                  _quiz(context, state.data);
                }
              },
              label: const Text("Quiz"),
              icon: const Icon(Icons.quiz),
            ),
            appBar: AppBar(
              title: Text(title),
              actions: [actionsLayout(args)],
            ),
            body: bodyComponent(state, fromWordsAndPhrases));
      },
    );
  }

  Widget bodyComponent(SublistState state, bool fromWordsAndPhrases) {
    if (state is SublistLoaded) {
      return wordListWidget(state.data, fromWordsAndPhrases, context);
    } else if (state is SublistLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SublistError) {
      return const ErrorComponent();
    } else {
      return const SizedBox();
    }
  }

  Widget actionsLayout(SublistDetailsArguments args) {
    return Visibility(
      visible: args.listId == wordsAndPhrases,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (pageNumber > 1) {
                pageNumber--;
                BlocProvider.of<SublistBloc>(context)
                    .add(WordsAndPhrasesData(pageNumber));
              }
            },
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            onPressed: () {
              pageNumber++;
              BlocProvider.of<SublistBloc>(context)
                  .add(WordsAndPhrasesData(pageNumber));
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  void _quiz(BuildContext context, List<String> wordList) {
    createQuestion(wordList, context, 1);
    Navigator.pushNamed(context, QuizScreen.routeName,
        arguments: QuizScreenArgs(wordList));
  }
}

class SublistDetailsArguments {
  final int listId;

  SublistDetailsArguments(this.listId);
}
