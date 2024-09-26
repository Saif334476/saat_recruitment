import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/company_pages/company_new_ad_posting.dart';
import '../Models/mcq_model.dart';
import 'company_upload_documents.dart';

class PreviewPage extends StatefulWidget {
  final List<MCQ> mcq;
  final String jobTitle;
  final String selectedCategory;
  final String jobType;
  final String requiredExperience;
  final String location;
  final String salary;
  final String selectedOption;
  final String jobId;
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
      required this.jobId});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final dateTime = DateTime.now();
  final date = DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _saveMCQs() async {
    // Save MCQs to Firestore logic
  }

  Future<void> _linkMCQs() async {
    // Link MCQs to job posting logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Job Posting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Job Posting Preview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Job Title: ${widget.jobTitle}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Job Category: ${widget.selectedCategory}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Job Type: ${widget.jobType}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Required Experience: ${widget.requiredExperience}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Job Location: ${widget.location}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Salary: ${widget.salary}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  color: const Color(0xff1C4374),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
                CupertinoButton(
                  color: const Color(0xff1C4374),
                  onPressed: () async {
                    if (widget.selectedOption == 'No') {
                      // Post job without MCQs logic
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(uid)
                          .collection('Job Ads')
                          .doc(widget.jobId)
                          .set({
                        'Title': widget.jobTitle,
                        'JobCategory': widget.selectedCategory,
                        'JobType': widget.jobType,
                        'RequiredExperience': widget.requiredExperience,
                        'JobLocation': widget.location,
                        'Salary': widget.salary,
                      });
                    } else {
                      // Post job with MCQs logic
                      await _saveMCQs();
                      await _linkMCQs();
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CompanyNewAdPosting()));
                  },
                  child: const Text(
                    'Post Job',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: const Color(0xff1C4374),
    //     title: const Text(
    //       "Preview Job AD",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20),
    //     child: ListView.builder(
    //       itemCount: widget.mcq.length,
    //       itemBuilder: (context, index) {
    //         return Column(
    //           children: [
    //             Text(
    //               'Question ${index + 1}: ${widget.mcq[index].question}',
    //             ),
    //             const SizedBox(height: 10),
    //             Text('Option 1: ${widget.mcq[index].option1}'),
    //             Text('Option 2: ${widget.mcq[index].option2}'),
    //             Text('Option 3: ${widget.mcq[index].option3}'),
    //             Text('Option 4: ${widget.mcq[index].option4}'),
    //             const SizedBox(height: 15),
    //             Text(
    //               'Correct Answer: ${widget.mcq[index].correctAnswer}',
    //             ),
    //             const SizedBox(height: 25),
    //             const Divider(
    //               thickness: 2,
    //             ),
    //           ],
    //         );
    //       },
    //     ),
    //   ),
    //   bottomNavigationBar: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       CupertinoButton(
    //         color: Colors.blueGrey,
    //         child: const Text(
    //           "Back",
    //           style: TextStyle(
    //             fontWeight: FontWeight.w900,
    //             color: Colors.white,
    //           ),
    //         ),
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //       ),
    //       CupertinoButton(
    //         color: Colors.blueGrey,
    //         child: const Text(
    //           "Save",
    //           style: TextStyle(
    //             fontWeight: FontWeight.w900,
    //             color: Colors.white,
    //           ),
    //         ),
    //         onPressed: () async {
    //           // final jobService = JobService();
    //           // await jobService.createMCQ(DateTime.now().toString(), widget.mcq);
    //           Navigator.pop(context);
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
