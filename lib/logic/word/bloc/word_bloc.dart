import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/word.dart';
import '../../../data/repository/word_repo.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  Word? word;
  final WordRepo wordRepo;

  WordBloc(
    this.wordRepo,
  ) : super(WordInitial()) {
    on<LoadWord>((event, emit) async {
      emit(WordLoading());
      await Future.delayed(const Duration(seconds: 3), () async {
        word = await WordRepo().fetchWord(event);
        if (word == null) {
          emit(WordError());
        } else {
          emit(WordLoaded(word!, false));
        }
      });
    });

    on<PronIsPlaying>((event, emit) async {
      if (state is WordLoaded) {
        final state = this.state as WordLoaded;
        emit(WordLoaded(state.data, event.isPlaying));
      }
    });
  }
}
