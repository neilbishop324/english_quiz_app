import 'package:english_quiz_app/logic/sublist/bloc/sublist_bloc.dart';
import 'package:english_quiz_app/presentation/screens/sublist/sublist_details_screen.dart';
import 'package:english_quiz_app/util/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeComponent extends StatefulWidget {
  const HomeComponent({super.key});

  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          listBox(context, wordsAndPhrases)
              .paddingSymmetric(horizontal: 8)
              .paddingTop(8),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return listBox(context, index);
            },
          ).paddingSymmetric(horizontal: 8).paddingBottom(8),
        ],
      ),
    );
  }

  Widget listBox(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(4, 6), // changes position of shadow
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (index == wordsAndPhrases) {
              BlocProvider.of<SublistBloc>(context).add(WordsAndPhrasesData(1));
            } else {
              BlocProvider.of<SublistBloc>(context).add(SublistData(index));
            }
            Navigator.pushNamed(context, SublistDetailsScreen.routeName,
                arguments: SublistDetailsArguments(index));
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              (index == wordsAndPhrases)
                  ? "Words and Phrases"
                  : "AWL Sublist ${index + 1}",
              style: const TextStyle(fontSize: 18),
            ).paddingAll(20),
          ),
        ),
      ),
    ).paddingAll(8).cornerRadiusWithClipRRect(8);
  }
}
