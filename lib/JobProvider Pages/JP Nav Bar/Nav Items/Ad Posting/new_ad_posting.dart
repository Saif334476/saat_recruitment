import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Models/job.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import '../../../../Models/mcq_model.dart';
import 'ad_mcqs.dart';
import 'ad_preview_page.dart';

class CompanyNewAdPosting extends StatefulWidget {
  final String? jobAdId;
  final Job? jobAdData;
  const CompanyNewAdPosting({super.key, this.jobAdData, required this.jobAdId});

  @override
  CompanyNewAdPostingState createState() => CompanyNewAdPostingState();
}

class CompanyNewAdPostingState extends State<CompanyNewAdPosting> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final dateTime = DateTime.now();
  final date = DateTime.now().millisecondsSinceEpoch.toString();
  String _selectedOption = "";
  String _selectedCategory = '';
  final TextEditingController _jobTitle = TextEditingController();
  String _jobType = '';
  String _requiredExperience = '';
  final TextEditingController _salary = TextEditingController();
  late final TextEditingController _location = TextEditingController();
  final TextEditingController _description = TextEditingController();
  List<MCQ> mcqList = [];
  final _formKey = GlobalKey<FormState>();
  bool? isActive;
  String _jobAdId = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.jobAdData != null) {
      _selectedOption = widget.jobAdData!.selectedOption;
      _jobTitle.text = widget.jobAdData!.jobTitle;
      _selectedCategory = widget.jobAdData!.selectedCategory;
      _location.text = widget.jobAdData!.location;
      _jobType = widget.jobAdData!.jobType;
      _selectedOption = widget.jobAdData!.selectedOption;
      _requiredExperience = widget.jobAdData!.requiredExperience;
      _salary.text = widget.jobAdData!.salary;
      _description.text = widget.jobAdData!.description;
      mcqList = widget.jobAdData!.mcq;
    } else {
      _selectedOption = '';
      _selectedCategory = '';
      _location.clear();
      _jobType = '';
      _requiredExperience = '';
      _jobTitle.clear();
      _salary.clear();
    }
    if (widget.jobAdId != null) {
      _jobAdId = widget.jobAdId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_selectedOption: $_selectedOption');

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text(
        //     "Job Posting",
        //     style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white,fontSize: 25),
        //   ),
        //   backgroundColor: const Color(0xff1C4374),
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(children: [
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 5),
              //   child: Container(
              //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all(color: const Color(0xff1C4374),width: 2)),
              //     child: const Padding(
              //       padding: EdgeInsets.only(top: 5.0,bottom: 5,right: 10,left: 10),
              //       child: Text(
              //         'Job Posting',
              //         style: TextStyle(
              //           shadows: [
              //             Shadow(
              //               offset: Offset(1.0, 1.0),
              //               color: Colors.black54,
              //               blurRadius: 2.0,
              //             ),
              //           ],
              //           fontWeight: FontWeight.w900,
              //           fontSize: 30,
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                height: 80,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Image.asset(
                                  "assets/job_posting.webp",
                                  color: const Color(0xff1C4374),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            textFormField(

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
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: dropDown(
                                isEditing:
                                    (widget.jobAdData == null) ? false : true,
                                value: _selectedCategory,
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
                                  'Education & Training',
                                  "Other"
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
                                isEditing:
                                    (widget.jobAdData == null) ? false : true,
                                value: _jobType,
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
                                isEditing:
                                    (widget.jobAdData == null) ? false : true,
                                value: _requiredExperience,
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
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _description,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                labelText: 'Description',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                              ),
                              maxLines: null, // Unlimited lines
                              minLines: 1, // Start with 1 line
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            placesAutoCompleteTextField(_location),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: textFormField(

                                  "Salary",
                                  Icons.currency_rupee_outlined,
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
                                isEditing:
                                    (widget.jobAdData == null) ? false : true,
                                value: _selectedOption,
                                items: ['Yes', 'No'].map((valued) {
                                  return DropdownMenuItem(
                                    value: valued,
                                    child: Text(valued),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Wanna add MCQs for this ad';
                                  }
                                  return null;
                                },
                                onChanged: (valued) {
                                  setState(() {
                                    _selectedOption = valued;
                                  });
                                },
                                text: 'Want to add mcqs for this ad',
                                icon: Icons.question_answer_outlined,
                              ),
                            ),
                            _selectedOption == 'No'
                                ? (widget.jobAdData != null)
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: CupertinoButton(
                                            color: const Color(0xff1C4374),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                Job job = Job(
                                                    jobId: _jobAdId,
                                                    jobTitle: _jobTitle.text,
                                                    selectedCategory:
                                                        _selectedCategory,
                                                    jobType: _jobType,
                                                    requiredExperience:
                                                        _requiredExperience,
                                                    location: _location.text,
                                                    salary: _salary.text,
                                                    selectedOption:
                                                        _selectedOption,
                                                    mcq: [],
                                                    postedBy: uid!,
                                                    postedAt: DateTime.now(),
                                                    description:
                                                        _description.text);

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PreviewPage(
                                                      job: job,
                                                      jobAdId: _jobAdId,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text(
                                              'Update Job Ad',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            )))
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: CupertinoButton(
                                            color: const Color(0xff1C4374),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                Job job = Job(
                                                    jobId: DateTime.now()
                                                        .toString(),
                                                    jobTitle: _jobTitle.text,
                                                    selectedCategory:
                                                        _selectedCategory,
                                                    jobType: _jobType,
                                                    requiredExperience:
                                                        _requiredExperience,
                                                    location: _location.text,
                                                    salary: _salary.text,
                                                    selectedOption:
                                                        _selectedOption,
                                                    mcq: [],
                                                    postedBy: uid!,
                                                    postedAt: DateTime.now(),
                                                    description:
                                                        _description.text);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PreviewPage(
                                                      job: job,
                                                      jobAdId: widget.jobAdId,
                                                    ),
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
                                            )))
                                : (widget.jobAdData != null)
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: CupertinoButton(
                                            color: const Color(0xff1C4374),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {



                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CompanyMCQCreationScreen(
                                                          jobTitle: _jobTitle.text,
                                                          jobType: _jobType,
                                                          jobCategory:
                                                          _selectedCategory,
                                                          location: _location.text,
                                                          salary: _salary.text,
                                                          selectedOption:
                                                          _selectedOption,
                                                          description:
                                                          _description.text,
                                                          requiredExperience:
                                                          _requiredExperience,
                                                      jobAdData:
                                                          widget.jobAdData,
                                                      jobId: _jobAdId,
                                                          jobAdId: widget.jobAdId,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text(
                                              'Proceed to MCQs',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18,
                                              ),
                                            )))
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: CupertinoButton(
                                          color: const Color(0xff1C4374),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // Job job = Job(
                                              //     jobId:
                                              //         DateTime.now().toString(),
                                              //     jobTitle: _jobTitle.text,
                                              //     selectedCategory:
                                              //         _selectedCategory,
                                              //     jobType: _jobType,
                                              //     requiredExperience:
                                              //         _requiredExperience,
                                              //     location: _location.text,
                                              //     salary: _salary.text,
                                              //     selectedOption:
                                              //         _selectedOption,
                                              //     mcq: [],
                                              //     postedBy: uid!,
                                              //     postedAt: DateTime.now(),
                                              //     description:
                                              //         _description.text);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CompanyMCQCreationScreen(
                                                    jobTitle: _jobTitle.text,
                                                    jobType: _jobType,
                                                    jobCategory:
                                                        _selectedCategory,
                                                    location: _location.text,
                                                    salary: _salary.text,
                                                    selectedOption:
                                                        _selectedOption,
                                                    description:
                                                        _description.text,
                                                    requiredExperience:
                                                        _requiredExperience,
                                                    jobAdData: null,
                                                 //   job: job,
                                                  ),
                                                ),
                                              );
                                            }
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
                                      )
                          ])))
            ]),
          ),
        ),
      ),
    );
  }
}
