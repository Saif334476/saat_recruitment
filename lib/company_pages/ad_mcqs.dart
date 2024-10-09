import 'package:flutter/material.dart';
import '../Models/mcq_model.dart';
import 'ad_preview_page.dart';
import 'mcq_card.dart';

class CompanyMCQCreationScreen extends StatefulWidget {
  final Map<String, dynamic>? jobAdData;
  final String jobId;
  final String selectedOption;
  final String salary;
  final String location;
  final String requiredExperience;
  final String jobType;
  final String selectedCategory;
  final String jobTitle;

  final String? jobAdId;
  const CompanyMCQCreationScreen(
      {super.key,
      required this.selectedOption,
      required this.salary,
      required this.location,
      required this.requiredExperience,
      required this.jobType,
      required this.selectedCategory,
      required this.jobTitle,
      this.jobAdData,
        this.jobAdId,
      required this.jobId});

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

  int questionCount = 10;
  int currentQuestion = 1;
  List<MCQ> mcqs = List.generate(
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

  void updateMCQ(MCQ newMCQ) {
    mcqs[currentQuestion - 1] = newMCQ;
    mcqs[currentQuestion - 1].correctAnswer = _correctAnswer;
  }

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
              "Please add mcqs carefully for better filtration",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xff1C4374),
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: MCQCard(
                  getSelectedAnswer: (answer) {
                    setState(() {
                      _correctAnswer = answer; // Update _correctAnswer
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
                        setState(() {
                          currentQuestion++;
                          _correctAnswer = ("Option 1"); // Reset _correctAnswer
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select a correct answer')),
                      );
                    }
                  },
                  onPrevious: () {
                    if (currentQuestion > 1) {
                      setState(() {
                        currentQuestion--;
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
                      if (currentQuestion < questionCount) {
                        setState(() {
                          currentQuestion++;
                         // _correctAnswer = ("Option 1"); // Reset _correctAnswer
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select a correct answer')),
                      );
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewPage(
                                  jobAdData: widget.jobAdData,
                                  mcq: mcqs,
                                  jobTitle: widget.jobTitle,
                                  selectedCategory: widget.selectedCategory,
                                  jobType: widget.jobType,
                                  requiredExperience: widget.requiredExperience,
                                  location: widget.location,
                                  salary: widget.salary,
                                  selectedOption: widget.selectedOption,
                                  jobId: widget.jobId,
                              jobAdId: widget.jobAdId,
                                )));
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
