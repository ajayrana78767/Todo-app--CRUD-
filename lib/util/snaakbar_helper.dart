import 'package:flutter/material.dart';

void showErrorMessage(
  BuildContext context, {
  required String message,
}) {
  final snakbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: (Colors.red),
  );
  ScaffoldMessenger.of(context).showSnackBar(snakbar);
}
void showSuccessMessage(
  BuildContext context, {
  required String message,
}) {
  final snakbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: (Colors.green),
  );
  ScaffoldMessenger.of(context).showSnackBar(snakbar);
}
