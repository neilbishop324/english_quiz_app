import 'package:audioplayers/audioplayers.dart';
import 'package:english_quiz_app/data/model/word.dart';
import 'package:english_quiz_app/logic/word/bloc/word_bloc.dart';
import 'package:english_quiz_app/presentation/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

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
  bool isInFavorites = false;

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
    return BlocConsumer<WordBloc, WordState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Word"),
          ),
          body: content(context, state),
          floatingActionButton: actionButtons(context, state),
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
    List<String> definitions = word.senses
        .map((e) => e.definitions)
        .expand((element) => element)
        .toList();

    List<String> shortDefinitions = word.senses
        .map((e) => e.shortDefinitions)
        .expand((element) => element)
        .toList();

    List<String> examples = word.senses
        .map((e) => e.examples)
        .expand((element) => element)
        .toList();

    List<String> types =
        word.senses.map((e) => e.types).expand((element) => element).toList();
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            wordHeader(context, word),
            textList("Etymologies", word.etymologies),
            textList("Definitions", definitions),
            textList("Examples", examples),
            textList("Categories", types),
            textList("Short Definitions", shortDefinitions),
          ],
        ),
      ),
    );
  }

  Widget wordHeader(BuildContext context, Word word) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          child: Column(
            children: [
              Text(
                word.en,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              (word.pronunciation?.phoneticSpelling != null)
                  ? Text(
                      word.pronunciation!.phoneticSpelling!,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : nothing(),
            ],
          ),
        ),
        (word.tr == null)
            ? 10.height
            : Text(
                word.tr!,
                style: Theme.of(context).textTheme.displaySmall,
              ).paddingSymmetric(vertical: 10),
      ],
    );
  }

  Widget textList(String title, List<String> elements) {
    if (elements.isEmpty) {
      return nothing();
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...elements.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final element = entry.value;
            return Text.rich(
              TextSpan(
                text: "$index. ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: element,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 20,
              ),
            );
          }).toList(),
          20.height
        ],
      ),
    );
  }

  Widget actionButtons(BuildContext context, WordState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "fab1",
          onPressed: () => addToFavorites(state),
          backgroundColor: redColor,
          child: Icon(
            (isInFavorites) ? Icons.favorite : Icons.favorite_border,
          ),
        ),
        16.height,
        FloatingActionButton(
          heroTag: "fab2",
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
          backgroundColor: midnightBlue,
          child: const Icon(Icons.volume_up),
        ),
      ],
    );
  }

  void addToFavorites(WordState state) async {
    isInFavorites = !isInFavorites;
    if (state is WordLoaded) {
      final wordBloc = context.read<WordBloc>();
      if (wordBloc.state is WordLoaded) {
        context.read<WordBloc>().add(AddFavorite(isInFavorites));
      }
    }
  }
}
