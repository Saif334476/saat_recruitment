import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Services/cloud_storage.dart';
import 'package:saat_recruitment/Services/firestore_services.dart';
import '../Models/job_provider.dart';
import '../reusable_widgets/file_preview.dart';
import 'JP Nav Bar/jp_nav_bar.dart';

class ReviewAndSubmitPage extends StatefulWidget {
  final File uploadedDocument;
  final String name;
  final String location;
  final String? industry;
  final String email;
  final String? companySize;
  const ReviewAndSubmitPage({
    super.key,
    required this.uploadedDocument,
    required this.name,
    required this.location,
    required this.industry,
    required this.email,
    required this.companySize,
  });

  @override
  State<ReviewAndSubmitPage> createState() => _ReviewAndSubmitPageState();
}

class _ReviewAndSubmitPageState extends State<ReviewAndSubmitPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  double uploadProgress = 0;
  late String companyIndustry;
  late String size;
  String profilePicUrl="";
  @override
  void initState() {
    super.initState();
    companyIndustry = widget.industry!;
    size = widget.companySize!;
  }

  Future<void> _uploadJobProviderData() async {
    try {
      FirestoreService firestoreServices = FirestoreService();
      FileUploadService fileUploadService = FileUploadService();
      final docUrl = await fileUploadService.uploadDocument(widget.uploadedDocument, uid!);
      JobProviderModel jobProvider = JobProviderModel(
        name: widget.name,
        industry: companyIndustry,
        location: widget.location,
        email: widget.email,
        companySize: size,
      );
      await firestoreServices.saveJobProviderData(uid!, jobProvider.toMap()) ;
      await FirebaseFirestore.instance.collection("Users").doc(uid).set(
          {"isComplete": true, 'isActive': false, 'docUrl': docUrl,'profilePicUrl':profilePicUrl},
          SetOptions(merge: true));
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    void showUploadDialog() {
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
                  value: uploadProgress,
                ),
                Text('Uploaded: (${(uploadProgress * 100).toInt()}%)'),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Review and Submit',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        backgroundColor: const Color(0xff1C4374),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Please review the selected document',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child:
                          getFilePreview(null, false, widget.uploadedDocument)),
                  // Image.file(widget.uploadedDocument),
                  const SizedBox(height: 20),
                  const Text(
                    'By submitting, you agree to our Terms and Conditions.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton(
                    color: const Color(0xff1C4374),
                    onPressed: () async {
                      _uploadJobProviderData();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CompanyDashBoard()));
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
