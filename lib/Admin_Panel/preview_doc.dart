import 'package:flutter/material.dart';

class PreviewDoc extends StatefulWidget {
  const PreviewDoc({super.key});

  @override
  State<PreviewDoc> createState() => _PreviewDocState();
}

class _PreviewDocState extends State<PreviewDoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C4374),
        automaticallyImplyLeading: false,
        title: const Text(
          "Document",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(),
      ),
    );
  }
}
