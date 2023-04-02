import 'package:flutter/material.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({Key? key, required this.body}) : super(key: key);
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
    );
  }
}
