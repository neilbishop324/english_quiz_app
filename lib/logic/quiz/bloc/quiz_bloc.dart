import 'package:bloc/bloc.dart';
import 'package:english_quiz_app/logic/word/bloc/word_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/question.dart';
import '../../../data/model/word.dart';
import '../../../data/repository/word_repo.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<AddQuestion>((event, emit) async {
      var questionIndex = 1;
      if (state is QuizLoaded) {
        questionIndex = (state as QuizLoaded).questionIndex;
      }
      emit(QuizLoading());
      await Future.delayed(const Duration(seconds: 3), () async {});
      var option1 = event.options[0];
      var option2 = event.options[1];
      var option3 = event.options[2];
      var option4 = event.options[3];
      final option1word =
          await WordRepo().fetchWord(LoadWord(option1.word, false));
      final option2word =
          await WordRepo().fetchWord(LoadWord(option2.word, false));
      final option3word =
          await WordRepo().fetchWord(LoadWord(option3.word, false));
      final option4word =
          await WordRepo().fetchWord(LoadWord(option4.word, false));
      option1.title = getOptionTitle(option1word);
      option2.title = getOptionTitle(option2word);
      option3.title = getOptionTitle(option3word);
      option4.title = getOptionTitle(option4word);
      Question question = Question(
          word: getQuestionWord(event.options),
          option1: option1,
          option2: option2,
          option3: option3,
          option4: option4);
      if (question.word.isEmpty ||
          event.options.firstWhere((element) => element.isTrue).title.isEmpty) {
        emit(QuizError("Question failed to load"));
      }
      emit(QuizLoaded(question, questionIndex));
    });
    on<ChangeQuestionIndex>((event, emit) {
      if (state is QuizLoaded) {
        final quizState = state as QuizLoaded;
        var newQuestionIndex = quizState.questionIndex + 1;
        if (event.questionSize < newQuestionIndex) {
          newQuestionIndex = newQuestionIndex - event.questionSize;
        }
        emit(QuizLoaded(quizState.question, newQuestionIndex));
      }
    });
    on<QuizFinishedEvent>((event, emit) {
      if (state is QuizLoaded) {
        emit(
            QuizFinished(trueSize: event.trueWord, falseSize: event.falseWord));
      }
    });
    on<QuizErrorEvent>((event, emit) {
      emit(QuizError(event.message));
    });
  }

  String getOptionTitle(Word? word) {
    if (word == null || word.senses.isEmpty) {
      return "";
    }
    for (int i = 0; i < word.senses.length; i++) {
      if (word.senses[i].definitions.isEmpty) {
        if (word.senses[i].shortDefinitions.isNotEmpty) {
          return word.senses[i].shortDefinitions[0];
        }
      } else {
        return word.senses[i].definitions[0];
      }
    }
    return "";
  }

  String getQuestionWord(List<Option> options) {
    for (Option option in options) {
      if (option.isTrue) {
        return option.word;
      }
    }
    return "";
  }
}
