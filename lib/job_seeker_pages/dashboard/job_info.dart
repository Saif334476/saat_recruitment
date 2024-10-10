import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<Map<String,dynamic>> mcqList = [] ;

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
  double _uploadProgress = 0;
  String? selectedFileName;
  File? selectedFile;

  void selectFile() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result!.files.isNotEmpty) {
      PlatformFile file = result!.files.first;
      setState(() {
        selectedFileName = file.name;
        selectedFile = File(file.path!);
      });
      showPreviewModal(selectedFile);
    }
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Uploading...'),
              LinearProgressIndicator(
                value: _uploadProgress,
              ),
              Text('Uploaded: (${(_uploadProgress * 100).toInt()}%)'),
            ],
          ),
        ),
      ),
    );
  }

  void updateFileOnFirestoreAndStorage(selectedFile) async {
    final users = FirebaseFirestore.instance.collection('Users');
    final docSnapshot = await users.doc(uid).get();

    if (docSnapshot.exists) {
      final existingResumeUrl = docSnapshot.get('resumeUrl');

      if (existingResumeUrl != null) {
        await FirebaseStorage.instance.refFromURL(existingResumeUrl).delete();
      }

      if (selectedFile != null) {
        _showUploadDialog();
        final newResumeUrl = await _uploadFileToStorage(selectedFile!);

        await users.doc(uid).update({
          'resumeUrl': newResumeUrl,
          'resumeFileName': selectedFileName,
        });
        Navigator.pop(context); // Close the dialog
      }
    }
  }

  Future<String?> _uploadFileToStorage(File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef
        .child('resumes/${DateTime.now().millisecondsSinceEpoch}.jpeg');
    String? downloadUrl;
    final uploadTask = fileRef.putFile(file);
    downloadUrl = await (await uploadTask).ref.getDownloadURL();
    await for (final snapshot in uploadTask.snapshotEvents) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      setState(() {
        _uploadProgress = progress;
      });
      // downloadUrl = await snapshot.ref.getDownloadURL();
    }
    return downloadUrl;
  }

  void showPreviewModal(selectedFile) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              const Text(
                'Resume Preview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                selectedFileName!,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                    color: const Color(0xff1C4374),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  CupertinoButton(
                    color: const Color(0xff1C4374),
                    onPressed: () {
                      updateFileOnFirestoreAndStorage(selectedFile);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showPreviewModals(String fileUrl) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 20,
          child: Column(
            children: [
              const Text(
                'Resume/CV',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(child: _getFilePreview(fileUrl)

                // FutureBuilder(
                //   future: FirebaseFirestore.instance.collection('JobProviders').doc(uid).get(),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       return _getFilePreview(snapshot.data!['resumeUrl']);
                //     } else {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //   },
                // ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                      color: const Color(0xff1C4374),
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    CupertinoButton(
                      color: const Color(0xff1C4374),
                      onPressed: () {
                        Navigator.pop(context);
                        selectFile();
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getFilePreview(String fileUrl) {
    Uri parsedUrl = Uri.parse(fileUrl);
    String fileExtension = parsedUrl.path.split('.').last.toLowerCase();

    if (fileExtension == 'pdf') {
      return const Text('PDF Preview not supported');
    } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension)) {
      return Image.network(fileUrl);
    } else if (['doc', 'docx'].contains(fileExtension)) {
      return const Text(
        'Microsoft Word Document',
        style: TextStyle(fontSize: 18),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      return const Text(
        'Microsoft Excel Spreadsheet',
        style: TextStyle(fontSize: 18),
      );
    } else {
      return const Text(
        'Unsupported file type',
        style: TextStyle(fontSize: 18),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Dialog(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff97C5FF),
                        borderRadius: BorderRadius.circular(20)),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  widget.jobAdData!['jobTitle'].toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close_outlined,
                                    size: 40,
                                    color: Colors.black,
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
                        color: const Color(0xff97C5FF),
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
                                "Requirements:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
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
                        color: const Color(0xff97C5FF),
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
                          if(companyInfo?['resumeUrl']==""){

                                       showPreviewModals(companyInfo?["resumeUrl"]);
                        }else{
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UploadCvResume()));
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
