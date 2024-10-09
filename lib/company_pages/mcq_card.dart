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
  const MCQCard({
    super.key,
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
  int _selectedAnswer = 0;

  String? validateOption(TextEditingController controller) {
    List<TextEditingController> options = [
      widget.option1Controller,
      widget.option2Controller,
      widget.option3Controller,
      widget.option4Controller,
    ];

    for (var option in options) {
      if (option.text == controller.text && option != controller) {
        return 'Duplicate option';
      }
    }

    if (controller.text.isEmpty) {
      return 'Please enter an option';
    }

    return null;
  }

  bool areOptionsUnique() {
    List<String> options = [
      widget.option1Controller.text,
      widget.option2Controller.text,
      widget.option3Controller.text,
      widget.option4Controller.text,
    ];

    return options.toSet().length == options.length &&
        options.every((element) => element.isNotEmpty);
  }

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
      _selectedAnswer = getAnswerIndex(_mcq.correctAnswer);
    } else {
      _mcq = MCQ(
        question: '',
        option1: '',
        option2: '',
        option3: '',
        option4: '',
        correctAnswer: null,
      );
    }
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
      _selectedAnswer = getAnswerIndex(_mcq.correctAnswer);
    }
    // _selectedAnswer = widget.correctAnswer.isEmpty ? 'Option 1' : widget.correctAnswer;
  }

  int getAnswerIndex(String? answer) {
    switch (answer) {
      case 'Option 1':
        return 1;
      case 'Option 2':
        return 2;
      case 'Option 3':
        return 3;
      case 'Option 4':
        return 4;
      default:
        return 0;
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
            padding: const EdgeInsets.only(bottom: 10.0, right: 50),
            child: textFormField(
              "Option 1",
              Icons.question_answer_outlined,
              false,
              keyboard: TextInputType.text,
              controller: widget.option1Controller,
              onChanged: () {},
              validator: (value) => validateOption(widget.option1Controller),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 50),
            child: textFormField(
              "Option 2",
              Icons.question_answer_outlined,
              false,
              keyboard: TextInputType.text,
              controller: widget.option2Controller,
              onChanged: () {},
              validator: (value) => validateOption(widget.option2Controller),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 50),
            child: textFormField(
              "Option 3",
              Icons.question_answer_outlined,
              false,
              keyboard: TextInputType.text,
              controller: widget.option3Controller,
              onChanged: () {},
              validator: (value) => validateOption(widget.option3Controller),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 50),
            child: textFormField(
              "Option 4",
              Icons.question_answer_outlined,
              false,
              keyboard: TextInputType.text,
              controller: widget.option4Controller,
              onChanged: () {},
              validator: (value) => validateOption(widget.option4Controller),
            ),
          ),
          const Text(
            'Select Correct Answer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(widget.option1Controller.text.isEmpty ? 'Option 1' : widget.option1Controller.text),
                  leading: Radio(
                    value: 1,
                    groupValue: _selectedAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswer = value as int;
                        widget.getSelectedAnswer(widget.option1Controller.text);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(widget.option2Controller.text.isEmpty ? 'Option 2' : widget.option2Controller.text),
                  leading: Radio(
                    value: 2,
                    groupValue: _selectedAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswer = value as int;
                        widget.getSelectedAnswer(widget.option2Controller.text);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(widget.option3Controller.text.isEmpty ? 'Option 3' : widget.option3Controller.text),
                  leading: Radio(
                    value: 3,
                    groupValue: _selectedAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswer = value as int;
                        widget.getSelectedAnswer(widget.option3Controller.text);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(widget.option4Controller.text.isEmpty ? 'Option 4' : widget.option4Controller.text),
                  leading: Radio(
                    value: 4,
                    groupValue: _selectedAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswer = value as int;
                        widget.getSelectedAnswer(widget.option4Controller.text);
                      });
                    },
                  ),
                ),
              ),
            ],
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
                        onPressed: _selectedAnswer != 0
                            ? widget.onNext
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please select a correct answer'),
                                  ),
                                );
                              },
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
