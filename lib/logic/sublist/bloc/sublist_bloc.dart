import 'package:flutter/material.dart';

import 'package:english_quiz_app/data/model/sublist_word.dart';
import 'package:english_quiz_app/data/repository/sublist_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sublist_event.dart';
part 'sublist_state.dart';

class SublistBloc extends Bloc<SublistEvent, SublistState> {
  late List<SublistWord> wordList;
  final SublistRepo sublistRepo;

  SublistBloc(
    this.sublistRepo,
  ) : super(SublistInitial()) {
    on<SublistEvent>((event, emit) async {
      if (event is SublistData) {
        emit(SublistLoading());
        await Future.delayed(const Duration(seconds: 3), () async {
          final wordListSS =
              await SublistRepo().fetchSublist(listId: event.listId);
          if (wordListSS == null) {
            emit(SublistError());
          } else {
            emit(SublistLoaded(wordListSS));
          }
        });
      }
    });
  }
}
