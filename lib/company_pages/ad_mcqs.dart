import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          Expanded(
            child: Wrap(
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

class MCQ {
  String question = '';
  String option1 = '';
  String option2 = '';
  String option3 = '';
  String option4 = '';
  String correctAnswer = '';
}

class MCQCard extends StatelessWidget {
  final MCQ mcq;
  final int questionNumber;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const MCQCard({
    super.key,
    required this.mcq,
    required this.questionNumber,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // shrinkWrap: true,
      //physics: NeverScrollableScrollPhysics(),
      children: [
        Text('Question #$questionNumber'),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Question',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a question';
            }
            return null;
          },
          onChanged: (text) {
            mcq.question = text;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Option 1',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter option 1';
            }
            return null;
          },
          onChanged: (text) {
            mcq.option1 = text;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Option 2',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter option 2';
            }
            return null;
          },
          onChanged: (text) {
            mcq.option2 = text;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Option 3',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter option 3';
            }
            return null;
          },
          onChanged: (text) {
            mcq.option3 = text;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Option 4',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter option 4';
            }
            return null;
          },
          onChanged: (text) {
            mcq.option4 = text;
          },
        ),
        DropdownButton(
          value: mcq.correctAnswer.isEmpty ? 'Option 1' : mcq.correctAnswer,
          onChanged: (value) {
            mcq.correctAnswer = value!;
          },
          items: const <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
              .map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onPrevious,
              child: const Text('Previous'),
            ),
            ElevatedButton(
              onPressed: onNext,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
