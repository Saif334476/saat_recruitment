import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Services/firestore_services.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/apply_to_job.dart';

class ConductMcqs extends StatefulWidget {
  final List<Map<String, dynamic>> mcqList;
  final String uid;
  final String existingResumeUrl;
  final String jobAdId;
  const ConductMcqs(
      {super.key,
      required this.mcqList,
      required this.existingResumeUrl,
      required this.uid,
      required this.jobAdId});

  @override
  State<ConductMcqs> createState() => _ConductMcqsState();
}

class _ConductMcqsState extends State<ConductMcqs> {
  int _currentQuestion = 0;
  int _score = 0;
  String _selectedOption = '';
  int _questionCount = 1;
  FirestoreService firestoreService=FirestoreService();
  final uid=FirebaseAuth.instance.currentUser?.uid;

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "MCQs Quiz",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        backgroundColor: const Color(0xff1C4374),
      ),
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
                        final String result = _score >= 7 ? 'Passed' : 'Failed';
                        final Color resultColor =
                            _score >= 7 ? Colors.green : Colors.red;

                        return AlertDialog(
                          content: SizedBox(
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Your score is $_score/${widget.mcqList.length}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
                                ),
                                Text(
                                  result,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: resultColor,
                                    fontSize: 18,
                                  ),
                                ),
                                // IconButton(
                                //   onPressed: () {
                                //     Navigator.pop(context);
                                //   },
                                //   icon: const Icon(Icons.done, size: 50),
                                // ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (_score >= 7) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ApplyToJob(
                                              widget.uid, widget.jobAdId,
                                              existingResumeUrl:
                                                  widget.existingResumeUrl)));
                                } else {
                                  firestoreService.saveApplicationAtJS(widget.jobAdId, uid!,"UnSuccessful");
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
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
