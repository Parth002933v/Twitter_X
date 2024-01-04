import 'package:flutter/material.dart';

Widget Loader() {
  return Center(child: CircularProgressIndicator());
}

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Loader();
  }
}
