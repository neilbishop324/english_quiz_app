import 'package:english_quiz_app/logic/sublist/bloc/sublist_bloc.dart';
import 'package:english_quiz_app/presentation/screens/sublist/sublist_details_screen.dart';
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
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              BlocProvider.of<SublistBloc>(context).add(SublistData(index + 1));
              Navigator.pushNamed(context, SublistDetailsScreen.routeName,
                  arguments: SublistDetailsArguments(index + 1));
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
                "Sublist ${index + 1}",
                style: const TextStyle(fontSize: 18),
              ).paddingAll(20),
            ).paddingAll(8).cornerRadiusWithClipRRect(8),
          );
        },
      ).paddingAll(8),
    );
  }
}
