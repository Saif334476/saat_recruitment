import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Models/job.dart';
import '../../../../Models/mcq_model.dart';
import 'ad_preview_page.dart';
import 'mcq_card.dart';

class CompanyMCQCreationScreen extends StatefulWidget {
  final String? jobTitle;
  final String? jobCategory;
  final String? jobType;
  final String? salary;
  final String? location;
  final String? requiredExperience;
  final String? description;
  final String? selectedOption;
  final String? mcq;
  final Job? jobAdData;
  final Job? job;
  final String? jobId;
  final String? jobAdId;

  const CompanyMCQCreationScreen({
    super.key,
    required this.jobAdData,
    this.job,
    this.jobId,
    this.jobTitle,
    this.jobCategory,
    this.salary,
    this.location,
    this.requiredExperience,
    this.description,
    this.selectedOption,
    this.mcq, this.jobType, this.jobAdId,
  });

  @override
  CompanyMCQCreationScreenState createState() =>
      CompanyMCQCreationScreenState();
}

class CompanyMCQCreationScreenState extends State<CompanyMCQCreationScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  String _correctAnswer = '';
  final uid = FirebaseAuth.instance.currentUser?.uid;
  int questionCount = 10;
  int currentQuestion = 1;
  List<MCQ> mcqs = [];
  late Job job;
  void updateMCQ(MCQ newMCQ) {
    mcqs[currentQuestion - 1] = newMCQ;
    mcqs[currentQuestion - 1].correctAnswer = _correctAnswer;
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.jobAdData == null) {
      job = widget.job!;
      mcqs = List.generate(
        10,
        (index) => MCQ(
          question: '',
          option1: '',
          option2: '',
          option3: '',
          option4: '',
          correctAnswer: '',
        ),
      );
    } else {
      mcqs = widget.jobAdData!.mcq;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff1C4374),
        title: const Text(
          "MCQ's Creation",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 10, left: 10),
            child: Column(
              children: [
                (widget.jobAdData != null)
                    ? const Text(
                        "Editing Job Ad",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.lightBlue),
                      )
                    : Container(),
                const Text(
                  "Please add mcqs carefully for better filtration",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xff1C4374),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: MCQCard(
                    getSelectedAnswer: (answer) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _correctAnswer = answer; // Update _correctAnswer
                        });
                      });
                    },
                    mcq: mcqs[currentQuestion - 1],
                    questionNumber: currentQuestion,
                    questionController: _questionController,
                    option1Controller: _option1Controller,
                    option2Controller: _option2Controller,
                    option3Controller: _option3Controller,
                    option4Controller: _option4Controller,
                    correctAnswer: _correctAnswer,
                    onNext: () {
                      if (_formKey.currentState!.validate() &&
                          _correctAnswer.isNotEmpty) {
                        MCQ newMCQ = MCQ(
                          question: _questionController.text,
                          option1: _option1Controller.text,
                          option2: _option2Controller.text,
                          option3: _option3Controller.text,
                          option4: _option4Controller.text,
                          correctAnswer: _correctAnswer,
                        );
                        updateMCQ(newMCQ);
                        if (currentQuestion < questionCount) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              currentQuestion++;
                              _correctAnswer = ("Option 1");
                            });
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a correct answer'),
                            behavior: SnackBarBehavior.floating,
                            padding: EdgeInsets.all(10),
                          ),
                        );
                      }
                    },
                    onPrevious: () {
                      if (currentQuestion > 1) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            currentQuestion--;
                          });
                        });
                      }
                    },
                    onPreview: () {
                      if (_formKey.currentState!.validate() &&
                          _correctAnswer.isNotEmpty) {
                        MCQ newMCQ = MCQ(
                          question: _questionController.text,
                          option1: _option1Controller.text,
                          option2: _option2Controller.text,
                          option3: _option3Controller.text,
                          option4: _option4Controller.text,
                          correctAnswer: _correctAnswer,
                        );
                        updateMCQ(newMCQ);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select a correct answer')),
                        );
                        if (currentQuestion < questionCount) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              currentQuestion++;
                            });
                          });
                        }
                      }
                      if (widget.jobAdData == null) {
                        Job job = Job(
                            jobId: DateTime.now().toString(),
                            jobTitle: widget.jobTitle!,
                            selectedCategory: widget.jobCategory!,
                            jobType: widget.jobType!,
                            requiredExperience:widget.requiredExperience!,
                            location: widget.location!,
                            salary: widget.salary!,
                            selectedOption: widget.selectedOption!,
                            mcq: mcqs,
                            postedBy: uid!,
                            postedAt: DateTime.now(),
                            description: widget.description!);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewPage(
                                      job:job,
                                      jobId: DateTime.now().toString(),
                                    )));
                      } else {
                        Job job = Job(
                            jobId:widget.jobId!,
                            jobTitle: widget.jobTitle!,
                            selectedCategory: widget.jobCategory!,
                            jobType: widget.jobType!,
                            requiredExperience:widget.requiredExperience!,
                            location: widget.location!,
                            salary: widget.salary!,
                            selectedOption: widget.selectedOption!,
                            mcq: mcqs,
                            postedBy: uid!,
                            postedAt: DateTime.now(),
                            description: widget.description!);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewPage(
                                      job: job,
                                      jobId: widget.jobId,
                                  jobAdId: widget.jobAdId,
                                    )));
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
