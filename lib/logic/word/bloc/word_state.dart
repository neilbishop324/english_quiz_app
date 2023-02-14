part of 'word_bloc.dart';

@immutable
abstract class WordState {}

class WordInitial extends WordState {}

class WordLoading extends WordState {}

class WordLoaded extends WordState {
  final Word data;
  final bool isPlaying;
  final bool isInFavorites;

  WordLoaded(this.data, this.isPlaying, this.isInFavorites);
}

class WordError extends WordState {}
