import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/mcq_model.dart';
import '../reusable_widgets/reusable_widget.dart';

class MCQCard extends StatefulWidget {
  final MCQ? mcq;
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
  State<MCQCard> createState() => _MCQCardState();
}

class _MCQCardState extends State<MCQCard> with AutomaticKeepAliveClientMixin {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  late MCQ _mcq;

  MCQ getMCQ() {
    return MCQ(
        question: _questionController.text,
        option1: _option1Controller.text,
        option2: _option2Controller.text,
        option3: _option3Controller.text,
        option4: _option4Controller.text,
        correctAnswer: _mcq.correctAnswer);
  }

  @override
  void initState() {
    super.initState();
    if (widget.mcq != null) {
      _mcq = widget.mcq!;
      _questionController.text = _mcq.question;
      _option1Controller.text = _mcq.option1;
      _option2Controller.text = _mcq.option2;
      _option3Controller.text = _mcq.option3;
      _option4Controller.text = _mcq.option4;
    } else {
      _mcq = MCQ();
    }
  }

  @override
  void didUpdateWidget(MCQCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mcq != oldWidget.mcq) {
      if (widget.mcq != null) {
        _mcq = widget.mcq!;
        _questionController.text = _mcq.question;
        _option1Controller.text = _mcq.option1;
        _option2Controller.text = _mcq.option2;
        _option3Controller.text = _mcq.option3;
        _option4Controller.text = _mcq.option4;
      } else {
        _mcq = MCQ();
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Question #${widget.questionNumber}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 23),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: textFormField(
                "Please Enter a question", Icons.question_mark, false,
                keyboard: TextInputType.text,
                controller: _questionController,
                onChanged: () {}, validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a question';
              }
              return null;
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: textFormField(
              "Option 1",
              Icons.question_answer_outlined,
              false,
              keyboard: TextInputType.text,
              controller: _option1Controller,
              onChanged: () {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter option 1';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: textFormField(
              "Option 2",
              Icons.question_answer_outlined,
              false,
              keyboard: TextInputType.text,
              controller: _option2Controller,
              onChanged: () {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter option 2';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: textFormField(
              "Option 3",
              Icons.question_answer_outlined,
              false,
              keyboard: TextInputType.text,
              controller: _option3Controller,
              onChanged: () {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter option 3';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: textFormField(
              "Option 4",
              Icons.question_answer_outlined,
              false,
              keyboard: TextInputType.text,
              controller: _option4Controller,
              onChanged: () {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter option 4';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: DropdownButton(
              value:
                  _mcq.correctAnswer.isEmpty ? 'Option 1' : _mcq.correctAnswer,
              onChanged: (value) {
                setState(() {
                  _mcq.correctAnswer = value as String;
                });
              },
              items: const <String>[
                'Option 1',
                'Option 2',
                'Option 3',
                'Option 4'
              ].map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  color: const Color(0xff1C4374),
                  onPressed: widget.onPrevious,
                  child: const Text(
                    'Previous',
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
                CupertinoButton(
                  color: const Color(0xff1C4374),
                  onPressed: widget.onNext,
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
