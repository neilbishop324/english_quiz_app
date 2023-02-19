// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quiz_bloc.dart';

@immutable
abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final Question question;
  final int questionIndex;
  QuizLoaded(
    this.question,
    this.questionIndex,
  );
}

class QuizError extends QuizState {
  final String error;
  QuizError(this.error);
}

class QuizFinished extends QuizState {
  final int correctAnswer;
  final int incorrectAnswer;
  QuizFinished({
    required this.correctAnswer,
    required this.incorrectAnswer,
  });
}
