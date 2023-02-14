part of 'word_bloc.dart';

@immutable
abstract class WordState {}

class WordInitial extends WordState {}

class WordLoading extends WordState {}

class WordLoaded extends WordState {
  final Word data;
  final bool isPlaying;

  WordLoaded(this.data, this.isPlaying);
}

class WordError extends WordState {}
