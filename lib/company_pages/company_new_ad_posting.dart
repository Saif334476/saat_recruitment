import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/company_pages/ad_mcqs.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';

import '../Models/mcq_model.dart';
import 'ad_preview_page.dart';
import 'company_upload_documents.dart';

class CompanyNewAdPosting extends StatefulWidget {
  const CompanyNewAdPosting({super.key});

  @override
  CompanyNewAdPostingState createState() => CompanyNewAdPostingState();
}

class CompanyNewAdPostingState extends State<CompanyNewAdPosting> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final dateTime = DateTime.now();
  final date = DateTime.now().millisecondsSinceEpoch.toString();
  String _selectedOption = '';
  String _selectedCategory = '';
  final TextEditingController _jobTitle = TextEditingController();
  String _jobType = '';
  String _requiredExperience = '';
  final TextEditingController _salary = TextEditingController();
   String _location='';

  List<MCQ> mcqList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _selectedOption = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          // color: Colors.white,
          child: ListView(children: [
            Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: SizedBox(
                              height: 120,
                              width: 200,
                              child: Image.asset(
                                "assets/job_posting.webp",
                                color: const Color(0xff1C4374),
                              ),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(bottom: 00),
                              child: Text(
                                "JOB POSTING",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w900),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: textFormField(
                                onChanged: () {
                                  setState(() {});
                                },
                                "Enter Job Title",
                                Icons.title_outlined,
                                false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter Job title";
                                  }
                                  return null;
                                },
                                controller: _jobTitle,
                                keyboard: TextInputType.text),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: dropDown(
                              items: [
                                'IT & Technology',
                                'Healthcare',
                                'Sales & Marketing',
                                'Finance & Accounting',
                                'Customer Service',
                                'Administration & HR',
                                'Engineering & Manufacturing',
                                'Creative & Design',
                                'Hospitality & Tourism',
                                'Education & Training'
                              ].map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Select Job Category';
                                }
                                return null;
                              },
                              text: 'Job Category',
                              icon: Icons.category_outlined,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: dropDown(
                              items: [
                                'Remote',
                                'Full-time',
                                'Part-time',
                                'Contract',
                                'Freelance',
                                'Internship',
                              ].map((jobType) {
                                return DropdownMenuItem(
                                  value: jobType,
                                  child: Text(jobType),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Select Job Type';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _jobType = value;
                              },
                              text: 'Job Type',
                              icon: Icons.type_specimen_rounded,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: dropDown(
                              items: [
                                'No',
                                'One Year',
                                'Two Years',
                                'Three Years',
                                'Five Years',
                              ].map((jobExperience) {
                                return DropdownMenuItem(
                                  value: jobExperience,
                                  child: Text(jobExperience),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Select Job Experience';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _requiredExperience = value;
                              },
                              text: 'Required Experience',
                              icon: Icons.type_specimen_rounded,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: dropDown(
                              items: [
                                'Karachi',
                                'Lahore',
                                'Faisalabad',
                                'Rawalpindi',
                                'Multan',
                                'Gujranwala',
                                'Hyderabad',
                                'Peshawar',
                                'Islamabad',
                                'Quetta',
                                'Sargodha',
                                'Sialkot',
                                'Bahawalpur',
                                'Sukkur',
                                'Gujrat',
                                'Sahiwal',
                                'Okara',
                                'Jhang',
                                'D.G Khan',
                                'Chiniot',
                                'Jehlum',
                                'Khanewal',
                                'Kohat',
                                'Bawalnagar',
                                'Chakwal',
                                'Mianwali',
                              ].map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Select Job Location';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _location = value;
                                });
                              },
                              text: 'Job Location',
                              icon: Icons.my_location_outlined,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: textFormField(
                                onChanged: () {
                                  setState(() {});
                                },
                                "Salary",
                                Icons.currency_pound_outlined,
                                false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter Salary";
                                  }
                                  return null;
                                },
                                controller: _salary,
                                keyboard: TextInputType.text),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: dropDown(
                              items: [
                                'Yes',
                                'No',
                              ].map((jobExperience) {
                                return DropdownMenuItem(
                                  value: jobExperience,
                                  child: Text(jobExperience),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Wanna add MCQs for this ad';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _requiredExperience = value;
                                  _selectedOption = value;
                                  // if (value == "Yes") {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const CompanyMCQCreationScreen()),
                                  //   );
                                  // }
                                });
                              },
                              text: 'Want to add mcqs for this ad',
                              icon: Icons.question_answer_outlined,
                            ),
                          ),
                          _selectedOption == 'No'
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CupertinoButton(
                                    color: const Color(0xff1C4374),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
      
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PreviewPage(
                                              jobTitle: _jobTitle.text,
                                              selectedCategory: _selectedCategory,
                                              jobType: _jobType,
                                              requiredExperience: _requiredExperience,
                                              location: _location,
                                              salary: _salary.text,
                                              selectedOption: _selectedOption,
                                              jobId: dateTime.toString(), mcq: const [],
                                            ),
                                          ),
                                        );
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(uid)
                                              .collection('Job Ads')
                                              .doc(dateTime.toString())
                                              .set({
                                            'Title': _jobTitle.text,
                                            'JobCategory': _selectedCategory,
                                            'JobType': _jobType,
                                            'RequiredExperience':
                                                _requiredExperience,
                                            'JobLocation': _location,
                                            'Salary': _salary.text
                                          });
                                        } catch (e) {
                                          print('Error setting document: $e');
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CompanyVerificationPage(),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Post Job',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18),
                                    ),
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CupertinoButton(
                                          color: const Color(0xff1C4374),
                                          onPressed: () async {
                                            // Post job with MCQs logic
                                            // Navigate to MCQ creation screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CompanyMCQCreationScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Post Job with MCQs',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ]),
                                )
                        ])))
          ])),
    );
  }
}
