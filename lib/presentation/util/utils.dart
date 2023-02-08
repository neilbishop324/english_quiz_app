import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Widget eqTextField(
    {required TextEditingController controller, required String placeHolder}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: placeHolder),
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
