import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Services/firestore_services.dart';
import '../../../../Models/job.dart';
import '../../../../Models/mcq_model.dart';
import '../../jp_nav_bar.dart';

class PreviewPage extends StatefulWidget {
  final Map<String, dynamic>? jobAdData;
  final Job job;
  final String? jobId;
  final String? jobAdId;
  const PreviewPage(
      {super.key,
      required this.job,
      this.jobId,
      this.jobAdData,
      this.jobAdId});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final dateTime = DateTime.now();
  final date = DateTime.now().millisecondsSinceEpoch.toString();
  FirestoreService firestoreService=FirestoreService();

  Future<void> _saveJobAd() async {
    Map<String, dynamic> jobData = widget.job.toMap();
    await firestoreService.saveNewJob(jobData);

  }

  Future<void> _updateJobAd() async {
    Map<String, dynamic> jobData = widget.job.toMap();
    await firestoreService.saveNewJob(jobData);

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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Text(
                        widget.job.jobTitle,
                        style: const TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Job Category: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.job.selectedCategory,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Job Type: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Text(
                        widget.job.jobType,
                        style: const TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Req. Experience: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Text(
                        widget.job.requiredExperience,
                        style: const TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                  const Icon(Icons.location_on_outlined,color: Color(0xff1C4374),),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Text(
                        widget.job.location,
                        style: const TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Salary: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.job.salary,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 20),
              const Divider(),
              widget.job.selectedOption == 'No'
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
                              itemCount: widget.job.mcq.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Text(
                                      'Question ${index + 1}: ${widget.job.mcq[index].question}',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        'Option 1: ${widget.job.mcq[index].option1}'),
                                    Text(
                                        'Option 2: ${widget.job.mcq[index].option2}'),
                                    Text(
                                        'Option 3: ${widget.job.mcq[index].option3}'),
                                    Text(
                                        'Option 4: ${widget.job.mcq[index].option4}'),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Correct Answer: ${widget.job.mcq[index].correctAnswer}',
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
              if (widget.jobAdData != null) {
                _updateJobAd();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const CompanyDashBoard()));
              } else {
                _saveJobAd();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const CompanyDashBoard()));
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
