import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../logic/word/bloc/word_bloc.dart';
import '../screens/word/word_screen.dart';

Widget eqTextField(
    {required TextEditingController controller,
    required String placeHolder,
    required TextInputType type,
    required bool required}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: type == TextInputType.visiblePassword,
    enableSuggestions: type != TextInputType.visiblePassword,
    autocorrect: type != TextInputType.visiblePassword,
    decoration: InputDecoration(labelText: placeHolder),
    validator: (value) {
      if (value.isEmptyOrNull && required) {
        return '$placeHolder is required';
      }
      return null;
    },
  ).paddingAll(16);
}

Widget eqButton({required String text, required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(200, 50))),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18),
    ),
  ).cornerRadiusWithClipRRect(30).paddingAll(12);
}

Widget nothing() {
  return const SizedBox();
}

Widget wordListWidget(
    List<String> data, bool fromWordsAndPhrases, BuildContext context) {
  return SingleChildScrollView(
    physics: const ScrollPhysics(),
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(4, 6), // changes position of shadow
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                BlocProvider.of<WordBloc>(context)
                    .add(LoadWord(data[index], !fromWordsAndPhrases));
                Navigator.pushNamed(context, WordScreen.routeName);
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  data[index],
                  style: const TextStyle(fontSize: 18),
                ).paddingAll(10),
              ),
            ),
          ),
        ).paddingAll(8).cornerRadiusWithClipRRect(8);
      },
    ).paddingAll(8),
  );
}
