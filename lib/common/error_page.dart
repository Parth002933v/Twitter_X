import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget errorText({
  required String error,
  required String stack,
}) {
  return Center(child: Text(error));
}

class ErrorPage extends StatelessWidget {
  final String error;
  final String stack;
  const ErrorPage({
    super.key,
    required this.error,
    required this.stack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: errorText(error: error, stack: stack),
    );
  }
}
