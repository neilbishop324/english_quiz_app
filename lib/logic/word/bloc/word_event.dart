// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'word_bloc.dart';

@immutable
abstract class WordEvent {}

class LoadWord extends WordEvent {
  final String word;
  final bool fromSublist;

  LoadWord(
    this.word,
    this.fromSublist,
  );
}

class PronIsPlaying extends WordEvent {
  final bool isPlaying;

  PronIsPlaying(this.isPlaying);
}
