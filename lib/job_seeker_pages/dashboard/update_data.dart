import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/preview_cv.dart';

class UpdateData extends StatefulWidget {
  final File selectedFile;
  final String? jobAdId;
  const UpdateData(this.selectedFile, this.jobAdId, {super.key});

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  
  String downloadUrl = "";
  FilePickerResult? result;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  String? selectedFileName;
  File? selectedFile;
  double _uploadProgress = 0;

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

      if (existingResumeUrl != "") {
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

    final uploadTask = fileRef.putFile(file);
    downloadUrl = await (await uploadTask).ref.getDownloadURL();
    await for (final snapshot in uploadTask.snapshotEvents) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      setState(() {
        _uploadProgress = progress;
      });
       downloadUrl = await snapshot.ref.getDownloadURL();
    }
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C4374),
        automaticallyImplyLeading: false,
        title: const Text(
          "Preview",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              child: Image.file(widget.selectedFile),
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                CupertinoButton(
                  color: const Color(0xff1C4374),
                  onPressed: () {
                    updateFileOnFirestoreAndStorage(widget.selectedFile);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewCv(uid, widget.jobAdId,
                                existingResumeUrl: downloadUrl)));
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
