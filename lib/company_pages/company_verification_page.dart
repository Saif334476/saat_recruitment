import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/company_pages/company_dashboard.dart';

class ReviewAndSubmitPage extends StatefulWidget {
  final File uploadedDocument;
  final String name;
  final String location;
  final String? industry;
  final String email;
  final String? companySize;
  const ReviewAndSubmitPage(
      {super.key,
      required this.uploadedDocument,
      required this.name,
      required this.location,
      this.industry,
      required this.email,
      this.companySize});

  @override
  State<ReviewAndSubmitPage> createState() => _ReviewAndSubmitPageState();
}

class _ReviewAndSubmitPageState extends State<ReviewAndSubmitPage> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    double uploadProgress = 0;
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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
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
                    'Please review the uploaded document',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 20),
                  Image.file(widget.uploadedDocument),
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
                      try {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .update({
                          'Name': widget.name,
                          'Location': widget.location,
                          'CompanySize': widget.companySize,
                          'Industry': widget.industry,
                          'Email': widget.email,
                          'isComplete': true,
                          'isActive': false
                        });
                      } catch (e) {
                        print('Error setting document: $e');
                      }
                      try {
                        final storageRef = FirebaseStorage.instance.ref(
                            'LegalDocs/${DateTime.now().millisecondsSinceEpoch}.jpeg');
                        showUploadDialog();
                        final uploadTask = storageRef.putFile(
                          widget.uploadedDocument,
                          SettableMetadata(
                            contentType: 'image/jpeg',
                          ),
                        );
                        uploadTask.snapshotEvents.listen((event) {
                          setState(() {
                            uploadProgress = event.bytesTransferred / event.totalBytes;
                          });
                        });
                        final downloadUrl =
                        await (await uploadTask).ref.getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .update({
                          'legalDocs': downloadUrl,
                          'legalDocsFileName':
                          widget.uploadedDocument.path.split('/').last,
                        });

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const CompanyDashBoard()));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to submit document'),
                          ),
                        );
                      }
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
