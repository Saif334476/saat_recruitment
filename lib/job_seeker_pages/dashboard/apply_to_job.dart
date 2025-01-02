import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Services/cloud_storage.dart';
import 'package:saat_recruitment/Services/firestore_services.dart';
import '../../Firebase Services/resume_utils.dart';
import '../../reusable_widgets/file_preview.dart';
import 'bottom_navigation/js_bottom_nav_bar.dart';

class ApplyToJob extends StatefulWidget {
  final String? uid;
  final String jobAdId;
  final String existingResumeUrl;
  const ApplyToJob(this.uid, this.jobAdId,
      {super.key, required this.existingResumeUrl});

  @override
  State<ApplyToJob> createState() => _ApplyToJobState();
}

class _ApplyToJobState extends State<ApplyToJob> {
  String jsId = FirebaseAuth.instance.currentUser!.uid;
  String? jobAdId;
  FilePickerResult? result;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  String? selectedFileName;
  File? selectedFile;
  double _uploadProgress = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirestoreService firestoreService = FirestoreService();
  FileUploadService fileUploadService = FileUploadService();
  late bool isApplied;

  void _uploadNewResume(selectedFile, uid) async {
    final profilePicUrl =
        await fileUploadService.uploadResume(selectedFile, uid);
    await firestoreService.uploadResumeUrl(uid, profilePicUrl);
    firestoreService.saveApplicationAtJS(widget.jobAdId, uid!, "Successful");
    firestoreService.sendApplicantDataToJP(
        widget.jobAdId, uid!, profilePicUrl, userEmail);
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressLoader(progress: _uploadProgress),
    );
  }

  void _applyTOJOb() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await firestoreService.sendApplicantDataToJP(
        widget.jobAdId, uid!, widget.existingResumeUrl, userEmail);
    await firestoreService.saveApplicationAtJS(
        widget.jobAdId, uid, "Successful");
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
      //getFilePreview(null,false,selectedFile);
      showPreviewModal(selectedFile, false);
    }
  }

  void showPreviewModal(resumeUrl, isUrl) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const Text(
                'Resume Preview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              isUrl
                  ? Expanded(child: getFilePreview(resumeUrl, true, null))
                  : Expanded(child: getFilePreview(null, false, resumeUrl)),
              // Text(
              //   selectedFileName!,
              //   style: const TextStyle(fontSize: 18),
              // ),
              const SizedBox(
                height: 20,
              ),
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
                    onPressed: () async {
                      _uploadNewResume(selectedFile, uid);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Application Successful'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Apply',
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
              child: getFilePreview(widget.existingResumeUrl, true, null),
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
                  onPressed: () {
                    _applyTOJOb();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Column(
                          children: [
                            Text(
                              'Application Successful',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                            Text(
                              "Your Resume sent to Advertiser,soon you will get response",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const JsBottomNavigationBar()),
                                (route) => false,
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
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
