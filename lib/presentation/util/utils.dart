import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

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
