import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/company_pages/company_dashboard.dart';
import '../Models/mcq_model.dart';

class PreviewPage extends StatefulWidget {
 final  Map<String, dynamic>? jobAdData;
  final List<MCQ> mcq;
  final String jobTitle;
  final String selectedCategory;
  final String jobType;
  final String requiredExperience;
  final String location;
  final String salary;
  final String selectedOption;
  final String? jobId;
  final String? jobAdId;
   const PreviewPage(
      {super.key,
      required this.mcq,
      required this.jobTitle,
      required this.selectedCategory,
      required this.jobType,
      required this.requiredExperience,
      required this.location,
      required this.salary,
      required this.selectedOption,
       this.jobId, this.jobAdData, this.jobAdId});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final dateTime = DateTime.now();
  final date = DateTime.now().millisecondsSinceEpoch.toString();

          Future<void> _saveJobAd() async {
            final jobRef = FirebaseFirestore.instance.collection('jobs').doc();
            try {
              await jobRef.set({
                'jobId': widget.jobId,
                'jobTitle': widget.jobTitle,
                'selectedCategory': widget.selectedCategory,
                'jobType': widget.jobType,
                'requiredExperience': widget.requiredExperience,
                'location': widget.location,
                'salary': widget.salary,
                'selectedOption': widget.selectedOption,
                'mcq': widget.mcq
            .map((mcq) => {
                  'question': mcq.question,
                  'option1': mcq.option1,
                  'option2': mcq.option2,
                  'option3': mcq.option3,
                  'option4': mcq.option4,
                  'correctAnswer': mcq.correctAnswer,
                })
            .toList(),
        'postedBy': uid,
        'postedAt': DateTime.now(),
      });
    } catch (e) {
      print('Error saving job posting: $e');
    }

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const CompanyDashBoard()));
  }
  Future<void> _updateJobAd() async {
    final jobRef = FirebaseFirestore.instance.collection('jobs').doc(widget.jobAdId);
    try {
      await jobRef.update({
        'jobId': widget.jobId,
        'jobTitle': widget.jobTitle,
        'selectedCategory': widget.selectedCategory,
        'jobType': widget.jobType,
        'requiredExperience': widget.requiredExperience,
        'location': widget.location,
        'salary': widget.salary,
        'selectedOption': widget.selectedOption,
        'mcq': widget.mcq
            .map((mcq) => {
          'question': mcq.question,
          'option1': mcq.option1,
          'option2': mcq.option2,
          'option3': mcq.option3,
          'option4': mcq.option4,
          'correctAnswer': mcq.correctAnswer,
        }).toList(),
        'postedBy': uid,
        'postedAt': DateTime.now(),
      });
    } catch (e) {
      print('Error saving job posting: $e');
    }

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const CompanyDashBoard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Job Posting'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(children: [
                const Text(
                  'Job Post Preview',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Job Title: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.jobTitle,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Job Category: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.selectedCategory,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Job Type: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.jobType,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Required Experience: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.requiredExperience,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Job Location: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.location,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Salary: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.salary,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 20),
              const Divider(),
              widget.selectedOption == 'No'
                  ? Container()
                  : Column(
                      children: [
                        const Text(
                          "MCQs",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 30),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 20, left: 20),
                          child: SizedBox(
                            height: 400,
                            child: ListView.builder(
                              itemCount: widget.mcq.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Text(
                                      'Question ${index + 1}: ${widget.mcq[index].question}',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        'Option 1: ${widget.mcq[index].option1}'),
                                    Text(
                                        'Option 2: ${widget.mcq[index].option2}'),
                                    Text(
                                        'Option 3: ${widget.mcq[index].option3}'),
                                    Text(
                                        'Option 4: ${widget.mcq[index].option4}'),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Correct Answer: ${widget.mcq[index].correctAnswer}',
                                    ),
                                    const SizedBox(height: 25),
                                    const Divider(
                                      thickness: 2,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CupertinoButton(
            color: const Color(0xff1C4374),
            child: const Text(
              "Back",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoButton(
            color: const Color(0xff1C4374),
            child: const Text(
              "Post",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if(widget.jobAdData!=null){
              _updateJobAd();
              }else{
                _saveJobAd();
              }
              // final jobService = JobService();
              // await jobService.createMCQ(DateTime.now().toString(), widget.mcq);
              //  Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
