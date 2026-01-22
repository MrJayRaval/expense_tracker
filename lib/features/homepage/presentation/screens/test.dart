import 'package:flutter/material.dart';

class TestingPage extends StatelessWidget {
  final String text;

  const TestingPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}