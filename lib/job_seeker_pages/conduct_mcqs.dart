import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConductMcqs extends StatefulWidget {
  final List<Map<String, dynamic>> mcqList;

  const ConductMcqs({super.key, required this.mcqList});

  @override
  State<ConductMcqs> createState() => _ConductMcqsState();
}

class _ConductMcqsState extends State<ConductMcqs> {
  int _currentQuestion = 0;
  int _score = 0;
  String _selectedOption = '';
  int _questionCount = 1;
  @override
  void initState() {
    super.initState();
    _currentQuestion = 0;
    _score = 0; // initialize score to 0
    _selectedOption = '';
    _questionCount = 1;
  }

  void checkAnswer(String? value) {
    setState(() {
      _selectedOption = value!;
      if (_selectedOption ==
          widget.mcqList[_currentQuestion]['correctAnswer']) {
        _score++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                child: Text(
                  "MCQs Quiz",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, right: 25, left: 30),
                child: SizedBox(
                  child: Text(
                    "Be careful, if you fail, you would not be able to apply on this job",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 20),
                    child: Text(
                      "Q $_questionCount. ${widget.mcqList[_currentQuestion]['question']}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      RadioListTile(
                        title:
                            Text(widget.mcqList[_currentQuestion]['option1']),
                        value: widget.mcqList[_currentQuestion]['option1'],
                        groupValue: _selectedOption,
                        onChanged: (value) => checkAnswer(value),
                      ),
                      RadioListTile(
                        title:
                            Text(widget.mcqList[_currentQuestion]['option2']),
                        value: widget.mcqList[_currentQuestion]['option2'],
                        groupValue: _selectedOption,
                        onChanged: (value) => checkAnswer(value),
                      ),
                      RadioListTile(
                        title:
                            Text(widget.mcqList[_currentQuestion]['option3']),
                        value: widget.mcqList[_currentQuestion]['option3'],
                        groupValue: _selectedOption,
                        onChanged: (value) => checkAnswer(value),
                      ),
                      RadioListTile(
                        title:
                            Text(widget.mcqList[_currentQuestion]['option4']),
                        value: widget.mcqList[_currentQuestion]['option4'],
                        groupValue: _selectedOption,
                        onChanged: (value) => checkAnswer(value),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                color: const Color(0xff1b3859),
                onPressed: () {
                  if (_currentQuestion < widget.mcqList.length - 1) {
                    setState(() {
                      _currentQuestion++;
                      _selectedOption = '';
                      _questionCount++;
                    });
                  } else {
                    // Show results
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                            'Your score is $_score/${widget.mcqList.length}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
