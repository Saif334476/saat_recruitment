import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/preview_cv.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/update_data.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/upload_cv_resume.dart';
import '../../Models/mcq_model.dart';
import '../application_submission.dart';
import '../conduct_mcqs.dart';

class JobInfo extends StatefulWidget {
  final Map<String, dynamic>? jobAdData;
  final String? jobAdId;
  const JobInfo({super.key, this.jobAdData, this.jobAdId});

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
      mcqList = List<Map<String, dynamic>>.from(widget.jobAdData!['mcq']);

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
  FilePickerResult? result;

  String? selectedFileName;
  File? selectedFile;


  // Widget _getFilePreview(String fileUrl) {
  //   Uri parsedUrl = Uri.parse(fileUrl);
  //   String fileExtension = parsedUrl.path.split('.').last.toLowerCase();
  //
  //   if (fileExtension == 'pdf') {
  //     return const Text('PDF Preview not supported');
  //   } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension)) {
  //     return Image.network(fileUrl);
  //   } else if (['doc', 'docx'].contains(fileExtension)) {
  //     return const Text(
  //       'Microsoft Word Document',
  //       style: TextStyle(fontSize: 18),
  //     );
  //   } else if (['xls', 'xlsx'].contains(fileExtension)) {
  //     return const Text(
  //       'Microsoft Excel Spreadsheet',
  //       style: TextStyle(fontSize: 18),
  //     );
  //   } else {
  //     return const Text(
  //       'Unsupported file type',
  //       style: TextStyle(fontSize: 18),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.jobAdData?['jobType'],
          style:
              const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        backgroundColor: const Color(0xff1C4374),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            style: BorderStyle.solid,
                            width: 2,
                            color: const Color(0xff1C4374)),
                        borderRadius: BorderRadius.circular(20)),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
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
                                        fontWeight: FontWeight.w700,
                                        fontSize: 30),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close_outlined,
                                    size: 40,
                                    color: Color(0xff1C4374),
                                  ))
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0, left: 8),
                              child: Icon(Icons.campaign_sharp),
                            ),
                            FutureBuilder(
                              future:
                                  companyName(widget.jobAdData!['postedBy']),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data?['Name'].toUpperCase() ??
                                      "---", // assuming 'companyName' is the field in Firestore
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
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
                                    padding:
                                        EdgeInsets.only(right: 8.0, left: 8),
                                    child: Icon(Icons.location_on_outlined),
                                  ),
                                  Text(
                                    _location,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
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
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  _jobType,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
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
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            style: BorderStyle.solid,
                            width: 2,
                            color: const Color(0xff1C4374)),
                        borderRadius: BorderRadius.circular(20)),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Requirements",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20,),
                              ),
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
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      _requiredExperience,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            style: BorderStyle.solid,
                            width: 2,
                            color: const Color(0xff1C4374)),
                        borderRadius: BorderRadius.circular(20)),
                    height: 320,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "DESCRIPTION",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 22),
                          ),
                          Text(
                              "sdgfsdghdfdshjfgdsfkjdshfkjdhskjfdskjfhdkjashfasdhfhjgh kjhsgkjhdfskj hvgsfj kjas hvkjasdh fkjdhasfhdkjas fkljsdh kjdshf dkjsh fkjshd fkjhdaskj fkjdhs  fkjhdskj hfkj hsdkjhf kjdshkjfh dkjskjf hdkjsh fkjhs kjdhs fkjhdskjh fkldjashfkj")
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                      color: const Color(0xff193d67),
                      onPressed: () {
                        if (mcqList.isNotEmpty) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ConductMcqs(mcqList: mcqList)));
                        } else {

                          if (companyInfo?['resumeUrl'] == ""){
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UploadCvResume()));
                          } else {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    PreviewCv(uid,widget.jobAdId,existingResumeUrl: companyInfo?["resumeUrl"],)));
                            // showPreviewModals(companyInfo?["resumeUrl"]);
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
      ),
    );
  }
}
