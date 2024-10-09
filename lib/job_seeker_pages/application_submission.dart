import 'package:flutter/material.dart';

class ApplicationSubmission extends StatefulWidget {
  const ApplicationSubmission({super.key});

  @override
  State<ApplicationSubmission> createState() => _ApplicationSubmissionState();
}

class _ApplicationSubmissionState extends State<ApplicationSubmission> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Application Submission"),
      ),
    );
  }
}
