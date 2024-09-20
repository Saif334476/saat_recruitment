import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/company_pages/validation_loader.dart';

class ReviewAndSubmitPage extends StatelessWidget {
  final File uploadedDocument;

  const ReviewAndSubmitPage({super.key, required this.uploadedDocument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Review and Submit',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
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
                  Image.file(uploadedDocument),
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
                      if (FirebaseAuth.instance.currentUser?.uid == null) {
                        // Handle user not logged in
                        return;
                      }

                      try {
                        final storageRef = FirebaseStorage.instance.ref(
                            'LegalDocs/${DateTime.now().millisecondsSinceEpoch}.jpeg');
                        final uploadTask = storageRef.putFile(uploadedDocument);
                        final downloadUrl =
                            await (await uploadTask).ref.getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection('JobProviders')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .set({
                          'resumeUrl': downloadUrl,
                          'resumeFileName':
                              uploadedDocument.path.split('/').last,
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SplashScreen()));
                      } catch (e) {
                        // Handle error
                        print('Error: $e');
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
