import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../Firebase Services/resume_utils.dart';

class PreviewCv extends StatefulWidget {
  final String? uid;
  final String? jobAdId;
  final String existingResumeUrl;
  const PreviewCv(this.uid, this.jobAdId,
      {super.key, required this.existingResumeUrl});

  @override
  State<PreviewCv> createState() => _PreviewCvState();
}

class _PreviewCvState extends State<PreviewCv> {
  String jsId = FirebaseAuth.instance.currentUser!.uid;
  String? jobAdId;
  FilePickerResult? result;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  String? selectedFileName;
  File? selectedFile;
  double _uploadProgress = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void applyToJob(String jobAdId, String uid) async {
    final jobAdRef = _firestore.collection('jobs').doc(jobAdId);
    final applicantRef = jobAdRef.collection('Applicants').doc(uid);
    final docSnapshot = await applicantRef.get();

    if (!docSnapshot.exists) {
      await applicantRef.set({'applicantId': uid,'resumeUrl':widget.existingResumeUrl});
      await jobAdRef.update({
        'numberOfApplicants': FieldValue.increment(1),
      });
      FirebaseFirestore.instance
          .collection("Users")
          .doc(jsId)
          .collection("Job Applications")
          .doc(jobAdId)
          .set({"applicationStatus": "Successful"},SetOptions(merge: true));

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Application Successful'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Show already applied dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('You have already applied for this job.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getJobAd(String uid) async {
    final jobAdRef = _firestore.collection('jobs').doc(uid);
    final jobAdDoc = await jobAdRef.get();

    if (jobAdDoc.exists) {
      return jobAdDoc;
    } else {
      throw Exception('Job ad not found');
    }
  }

  Future<void> _uploadResume(File selectedFile, String selectedFileName) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    _showUploadDialog();
    try {
      final newResumeUrl = await ResumeUtils().uploadFileToStorage(
          selectedFile, selectedFileName, (double progress) {
        setState(() {
          _uploadProgress = progress;
          print('Progress: $progress');
        });
      });

      await ResumeUtils()
          .saveResumeToFirestore(uid, newResumeUrl, selectedFileName);

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors
      Navigator.pop(context);
      print('Error uploading file: $e');
    }
    setState(() {});
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressLoader(progress: _uploadProgress),
    );
  }

  void selectFile() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg'],
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
                      setState(() {
                        _uploadResume(selectedFile, selectedFileName!);
                      });
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
              Expanded(child: _getFilePreview(fileUrl)),
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
      return SfPdfViewer.network(fileUrl);
    } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension)) {
      try {
        return Image.network(fileUrl);
      } catch (e) {
        return Text(
          'Error loading image: $e',
          style: const TextStyle(fontSize: 18),
        );
      }
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
  void initState() {
    super.initState();
    jobAdId = widget.jobAdId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C4374),
        automaticallyImplyLeading: false,
        title: const Text(
          "Existing CV",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              child: _getFilePreview(widget.existingResumeUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  color: const Color(0xff1C4374),
                  onPressed: () {
                    selectFile();
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                CupertinoButton(
                  color: const Color(0xff1C4374),
                  onPressed: () async {
                    final jobAdId = widget.jobAdId;
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    applyToJob(jobAdId!, uid!);
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
