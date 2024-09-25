import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';

import '../Models/mcq_model.dart';
import 'mcq_card.dart';

class CompanyMCQCreationScreen extends StatefulWidget {
  const CompanyMCQCreationScreen({super.key});

  @override
  CompanyMCQCreationScreenState createState() =>
      CompanyMCQCreationScreenState();
}

class CompanyMCQCreationScreenState extends State<CompanyMCQCreationScreen> {
  int questionCount = 10;
  int currentQuestion = 1;
  MCQ mcq = MCQ();
  List<MCQ> mcqList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MCQ's Creation",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xff1C4374),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff1C4374)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 15.0, right: 10, left: 10),
            child: Text(
              "Choose number of MCQ's to add for this job Ad",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xff1C4374),
              ),
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            children: [
              RadioListTile(
                title: const Text('10 questions'),
                value: 10,
                groupValue: questionCount,
                onChanged: (value) {
                  setState(() {
                    questionCount = value as int;
                  });
                },
              ),
              RadioListTile(
                title: const Text('20 questions'),
                value: 20,
                groupValue: questionCount,
                onChanged: (value) {
                  setState(() {
                    questionCount = value as int;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: MCQCard(
                  mcq: mcq,
                  questionNumber: currentQuestion,
                  onNext: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        if (currentQuestion < questionCount) {
                          mcqList.add(mcq);
                          currentQuestion++;
                          mcq = MCQ();
                          mcq.reset();
                        }
                      });
                    }
                  },
                  onPrevious: () {
                    setState(() {
                      if (currentQuestion > 1) {
                        mcqList.removeLast();
                        currentQuestion--;
                        mcq = mcqList.isEmpty ? MCQ() : mcqList.last;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


