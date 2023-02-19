// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sublist_bloc.dart';

@immutable
abstract class SublistEvent {}

class SublistData extends SublistEvent {
  final int listId;

  SublistData(
    this.listId,
  );
}

class WordsAndPhrasesData extends SublistEvent {
  final int pageNumber;

  WordsAndPhrasesData(this.pageNumber);
}
