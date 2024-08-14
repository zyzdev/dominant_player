import 'package:dominant_player/widgets/style.dart';
import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String info
}) {
  final snackBar = SnackBar(
    content: Center(
      child: Text(
        info,
        style: titleST.copyWith(color: Colors.redAccent),
      ),
    ),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}