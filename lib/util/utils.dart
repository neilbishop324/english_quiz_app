import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

List<T> pickRandomItemsAsList<T>(List<T> items, int count) =>
    (items.toList()..shuffle()).take(count).toList();
