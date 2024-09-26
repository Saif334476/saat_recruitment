import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/mcq_model.dart';
import '../reusable_widgets/reusable_widget.dart';

class MCQCard extends StatefulWidget {
  final MCQ? mcq;
  final int questionNumber;
  final TextEditingController questionController;
  final TextEditingController option1Controller;
  final TextEditingController option2Controller;
  final TextEditingController option3Controller;
  final TextEditingController option4Controller;
  final String correctAnswer;
  final Function(String) getSelectedAnswer;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onPreview;
 const  MCQCard(
      {super.key,
      required this.mcq,
      required this.questionNumber,
      required this.questionController,
      required this.option1Controller,
      required this.option2Controller,
      required this.option3Controller,
      required this.option4Controller,
        required this.correctAnswer,
       required this.getSelectedAnswer,
      required this.onNext,
      required this.onPrevious,
      required this.onPreview,
      });

  @override
  State<MCQCard> createState() => _MCQCardState();
}

class _MCQCardState extends State<MCQCard> with AutomaticKeepAliveClientMixin {
  late MCQ _mcq;
  String _selectedAnswer = 'Option 1';

  @override
  void initState() {
    super.initState();
    if (widget.mcq != null) {
      _mcq = widget.mcq!;
      widget.questionController.text = _mcq.question;
      widget.option1Controller.text = _mcq.option1;
      widget.option2Controller.text = _mcq.option2;
      widget.option3Controller.text = _mcq.option3;
      widget.option4Controller.text = _mcq.option4;

    } else {
      _mcq = MCQ(
        question: '',
        option1: '',
        option2: '',
        option3: '',
        option4: '',
        correctAnswer: null,
      );
    }_selectedAnswer = widget.correctAnswer;
  }

  @override
  void didUpdateWidget(MCQCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mcq != oldWidget.mcq) {
      _mcq = widget.mcq!;
      widget.questionController.text = _mcq.question;
      widget.option1Controller.text = _mcq.option1;
      widget.option2Controller.text = _mcq.option2;
      widget.option3Controller.text = _mcq.option3;
      widget.option4Controller.text = _mcq.option4;

    }_selectedAnswer = widget.correctAnswer;
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
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10),
            child: textFormField(
              "Please Enter a question",
              Icons.question_mark,
              false,
              keyboard: TextInputType.text,
              controller: widget.questionController,
              onChanged: () {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: textFormField(
              "Option 1",
              Icons.question_answer_outlined,
              false,
              keyboard: TextInputType.text,
              controller: widget.option1Controller,
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
              controller: widget.option2Controller,
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
              controller: widget.option3Controller,
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
              controller: widget.option4Controller,
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
              _selectedAnswer,
              onChanged: (value) {
                setState(() {
                  _selectedAnswer = value as String;
                  widget.getSelectedAnswer(_selectedAnswer);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.questionNumber == 10)
                    ? CupertinoButton(
                        color: const Color(0xff1C4374),
                        onPressed: widget.onPreview,
                        child: const Text(
                          "Preview",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ))
                    : CupertinoButton(
                        color: const Color(0xff1C4374),
                        onPressed: widget.onNext,
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CupertinoButton(
                    color: const Color(0xff1C4374),
                    onPressed: widget.onPrevious,
                    child: const Text(
                      'Previous',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
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
