import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResumeUtils {
  Future<String> uploadFileToStorage(File file, String selectedFileName,Function(double) onProgress) async {
    String? fileExtension = selectedFileName.split('.').last.toLowerCase();
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child(
        'resumes/${FirebaseAuth.instance.currentUser!.uid}.$fileExtension');

    UploadTask uploadTask = fileRef.putFile(file);
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress(progress); // Call the callback to update the progress
    });

    TaskSnapshot snapshot = await uploadTask;

    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveResumeToFirestore(
      String uid, String newResumeUrl, String selectedFileName) async {
    final users = FirebaseFirestore.instance.collection('Users');
    await users.doc(uid).update({
      'resumeUrl': newResumeUrl,
      'resumeFileName': selectedFileName,
    });
  }
}

class ProgressLoader extends StatelessWidget {
  final double progress;

  const ProgressLoader({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(value: progress),
            const SizedBox(height: 20),
            Text(
              '${(progress * 100).toStringAsFixed(2)}%',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
