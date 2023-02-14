import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nb_utils/nb_utils.dart';

class ErrorComponent extends StatelessWidget {
  const ErrorComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.error,
        color: redColor,
        size: 100,
      ),
    );
  }
}
