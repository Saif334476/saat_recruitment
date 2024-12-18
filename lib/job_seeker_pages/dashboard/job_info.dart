import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/apply_to_job.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/upload_cv_resume.dart';
import '../../Services/firestore_services.dart';
import '../application_submission.dart';
import '../conduct_mcqs.dart';

class JobInfo extends StatefulWidget {
  final Map<String, dynamic>? jobAdData;
  final String jobAdId;
  const JobInfo({super.key, this.jobAdData, required this.jobAdId});

  @override
  State<JobInfo> createState() => _JobInfoState();
}

class _JobInfoState extends State<JobInfo> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final dateTime = DateTime.now();
  final date = DateTime.now().millisecondsSinceEpoch.toString();
  String _selectedOption = "";
  String _selectedCategory = '';
  final TextEditingController _jobTitle = TextEditingController();
  String _jobType = '';
  String _requiredExperience = '';
  final TextEditingController _salary = TextEditingController();
  String _location = '';
  List<Map<String, dynamic>> mcqList = [];
  FirestoreService firestoreService = FirestoreService();
  bool _isApplied = false;
  String _description = '';
  Future<void> status() async {
    final isApplied =
        await firestoreService.checkApplicantStatus(uid!, widget.jobAdId);
    setState(() {
      _isApplied = isApplied;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.jobAdData != null) {
      _selectedOption = widget.jobAdData!['selectedOption'];
      _jobTitle.text = widget.jobAdData!['jobTitle'];
      _selectedCategory = widget.jobAdData!['selectedCategory'];
      _location = widget.jobAdData!['location'];
      _jobType = widget.jobAdData!['jobType'];
      _selectedOption = widget.jobAdData!['selectedOption'];
      _requiredExperience = widget.jobAdData!['requiredExperience'];
      _salary.text = widget.jobAdData!['salary'];
      _description = widget.jobAdData!['description'];
      mcqList = List<Map<String, dynamic>>.from(widget.jobAdData!['mcq']);
      status();
      fetchCompanyInfo(uid!).then((info) {
        setState(() {
          companyInfo = info;
        });
      });
    } else {
      _selectedOption = '';
      _selectedCategory = '';
      _location = '';
      _jobType = '';
      _requiredExperience = '';
      _jobTitle.clear();
      _salary.clear();
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> companyName(name) async {
    final named =
        await FirebaseFirestore.instance.collection('Users').doc(name).get();
    return named;
  }

  Future<Map<String, dynamic>?> fetchJobSeekerInfo(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return doc.data();
  }

  Map<String, dynamic>? companyInfo;

  String? selectedFileName;
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "JOB INFO.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       widget.jobAdData?['jobTitle'],
          //       style: const TextStyle(
          //           fontWeight: FontWeight.w900, color: Colors.white),
          //     ),
          //     IconButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         icon: const Icon(
          //           Icons.close_outlined,
          //           size: 30,
          //           color: Colors.white,
          //         ))
          //   ],
          // ),
          backgroundColor: const Color(0xff1C4374),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                widget.jobAdData!['jobTitle'].toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 30),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.blueGrey,
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0, left: 8),
                          child: Icon(Icons.campaign_sharp),
                        ),
                        FutureBuilder(
                          future: companyName(widget.jobAdData!['postedBy']),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data?['Name'].toUpperCase() ??
                                  "---", // assuming 'companyName' is the field in Firestore
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            );
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0, left: 8),
                                child: Icon(Icons.location_on_outlined),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  _location,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(children: [
                          const Text(
                            'Job Type:',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              _jobType,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ])),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Salary:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  _salary.text,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Text(
                                " PKR",
                                style: TextStyle(color: Colors.blueGrey),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Experience:',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              _requiredExperience,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Color(0xff1C4374),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "DESCRIPTION:",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      Text(_description)
                    ],
                  ),
                ),
                const Divider(
                  height: 10,
                  color: Color(0xff1C4374),
                ),
                const SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                    color: const Color(0xff193d67),
                    onPressed: () async {
                      if (_isApplied == true) {
                        _showAlreadyAppliedDialog(context);
                      } else {
                        if (mcqList.isNotEmpty) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConductMcqs(
                                        mcqList: mcqList,
                                        uid: uid!,
                                        jobAdId: widget.jobAdId,
                                        existingResumeUrl:
                                            companyInfo?["resumeUrl"],
                                      )));
                        } else {
                          if (companyInfo?['resumeUrl'] == "") {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UploadCvResume(
                                          uid: uid,
                                          existingResumeUrl:
                                              companyInfo?["resumeUrl"],
                                          jobAdId: widget.jobAdId,
                                        )));
                          } else {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ApplyToJob(
                                          uid,
                                          widget.jobAdId,
                                          existingResumeUrl:
                                              companyInfo?["resumeUrl"],
                                        )));
                            // showPreviewModals(companyInfo?["resumeUrl"]);
                          }
                        }
                      }
                    },
                    child: const Text(
                      "APPLY",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showAlreadyAppliedDialog(context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Already Applied'),
      content: const Text('You have already applied for this job.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
