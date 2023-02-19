import 'dart:math';

import 'package:english_quiz_app/services/account_service.dart';
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
          emit(WordError("Word was not found!"));
        } else {
          final inFavorites = await isInFavorites(word!.en);
          emit(WordLoaded(word!, false, inFavorites));
        }
      });
    });

    on<PronIsPlaying>((event, emit) async {
      if (state is WordLoaded) {
        final state = this.state as WordLoaded;
        emit(WordLoaded(state.data, event.isPlaying, state.isInFavorites));
      }
    });

    on<AddFavorite>((event, emit) async {
      if (state is WordLoaded) {
        final state = this.state as WordLoaded;
        AccountService().updateFavorites(
          shouldAdd: event.willBeFavorite,
          word: state.data.en,
          context: event.context,
        );
        emit(WordLoaded(state.data, state.isPlaying, event.willBeFavorite));
      }
    });
  }

  Future<bool> isInFavorites(String word) async {
    return AccountService().isInFavorites(word);
  }
}
