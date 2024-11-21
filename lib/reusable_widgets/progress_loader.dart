import 'package:flutter/material.dart';

class ProgressLoader extends StatefulWidget {
  final double progress;

  const ProgressLoader({required this.progress, super.key});

  @override
  State<ProgressLoader> createState() => ProgressLoaderState();
}

class ProgressLoaderState extends State<ProgressLoader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LinearProgressIndicator(
          value: widget.progress,
          backgroundColor: Colors.grey[200],
          color: Colors.blue,
        ),
      ),
    );
  }
}