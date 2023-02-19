import 'package:flutter/material.dart';

import 'package:english_quiz_app/data/model/sublist_word.dart';
import 'package:english_quiz_app/data/repository/sublist_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sublist_event.dart';
part 'sublist_state.dart';

class SublistBloc extends Bloc<SublistEvent, SublistState> {
  late List<SublistWord> wordList;
  final SublistRepo sublistRepo;
  var pageNumber = 1;

  SublistBloc(
    this.sublistRepo,
  ) : super(SublistInitial()) {
    on<SublistData>((event, emit) async {
      emit(SublistLoading());
      await Future.delayed(const Duration(seconds: 3), () async {
        final wordListSS =
            await SublistRepo().fetchSublist(listId: event.listId + 1);
        if (wordListSS == null) {
          emit(SublistError());
        } else {
          emit(SublistLoaded(wordListSS));
        }
      });
    });

    on<WordsAndPhrasesData>((event, emit) async {
      emit(SublistLoading());
      await Future.delayed(const Duration(seconds: 3), () async {
        pageNumber = event.pageNumber;
        final wordListSS =
            await SublistRepo().fetchWordsAndPhrases(pageNumber: pageNumber);
        if (wordListSS == null) {
          emit(SublistError());
        } else {
          emit(SublistLoaded(wordListSS));
        }
      });
    });
  }
}
