import 'package:english_quiz_app/data/model/sublist_word.dart';
import 'package:english_quiz_app/logic/word/bloc/word_bloc.dart';
import 'package:english_quiz_app/presentation/screens/error/components/error_component.dart';
import 'package:english_quiz_app/presentation/screens/word/word_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../logic/sublist/bloc/sublist_bloc.dart';

class SublistDetailsScreen extends StatefulWidget {
  const SublistDetailsScreen({super.key});

  static const String routeName = "/sublist_details";

  @override
  State<SublistDetailsScreen> createState() => _SublistDetailsScreenState();
}

class _SublistDetailsScreenState extends State<SublistDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SublistDetailsArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sublist ${args.listId}"),
      ),
      body: BlocConsumer<SublistBloc, SublistState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SublistLoaded) {
            return buildLoadedlayout(state.data);
          } else if (state is SublistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SublistError) {
            return const ErrorComponent();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget buildLoadedlayout(List<SublistWord> data) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              BlocProvider.of<WordBloc>(context)
                  .add(LoadWord(data[index].word, true));
              Navigator.pushNamed(context, WordScreen.routeName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Text(
                data[index].word,
                style: const TextStyle(fontSize: 18),
              ).paddingAll(10),
            ).paddingAll(8).cornerRadiusWithClipRRect(8),
          );
        },
      ).paddingAll(8),
    );
  }
}

class SublistDetailsArguments {
  final int listId;

  SublistDetailsArguments(this.listId);
}
