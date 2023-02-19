// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quiz_bloc.dart';

@immutable
abstract class QuizEvent {}

class AddQuestion extends QuizEvent {
  final List<Option> options;
  final int newIndex;
  AddQuestion({required this.options, required this.newIndex});
}

class ChangeQuestionIndex extends QuizEvent {
  final int questionSize;
  ChangeQuestionIndex(this.questionSize);
}

class QuizFinishedEvent extends QuizEvent {
  final int trueWord;
  final int falseWord;
  QuizFinishedEvent({
    required this.trueWord,
    required this.falseWord,
  });
}

class QuizErrorEvent extends QuizEvent {
  final String message;
  QuizErrorEvent(this.message);
}
