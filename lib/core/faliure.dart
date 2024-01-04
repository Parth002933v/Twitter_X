import 'package:flutter/material.dart';

@immutable
class Failure {
  final String error;
  final String stack;
  const Failure(this.error, this.stack);
}
