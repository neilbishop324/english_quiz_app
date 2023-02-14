import 'package:audioplayers/audioplayers.dart';
import 'package:english_quiz_app/data/model/word.dart';
import 'package:english_quiz_app/logic/word/bloc/word_bloc.dart';
import 'package:english_quiz_app/presentation/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../error/components/error_component.dart';

class WordScreen extends StatefulWidget {
  const WordScreen({super.key});

  static const String routeName = "/word";

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      final wordBloc = context.read<WordBloc>();
      if (wordBloc.state is WordLoaded) {
        isPlaying = state == PlayerState.playing;
        context.read<WordBloc>().add(PronIsPlaying(isPlaying));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordBloc, WordState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Word"),
          ),
          body: content(context, state),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (state is WordLoaded &&
                  state.data.pronunciation?.audioFile != null) {
                final pronFileLink = state.data.pronunciation!.audioFile!;
                if (isPlaying) {
                  await audioPlayer.pause();
                } else {
                  await audioPlayer.play(UrlSource(pronFileLink));
                }
              }
            },
            child: const Icon(Icons.volume_up),
          ),
        );
      },
    );
  }

  Widget content(BuildContext context, WordState state) {
    if (state is WordLoaded) {
      return buildLoadedlayout(state.data);
    } else if (state is WordLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WordError) {
      return const ErrorComponent();
    } else {
      return const SizedBox();
    }
  }

  Widget buildLoadedlayout(Word word) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            child: Text(
              word.en,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          (word.tr == null)
              ? nothing()
              : Text(
                  word.tr!,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
          Text("Etymologies: \n${word.etymologies.join('\n')}"),
        ],
      ),
    );
  }
}
