import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApplicationSubmission extends StatefulWidget {
  const ApplicationSubmission({super.key});

  @override
  State<ApplicationSubmission> createState() => _ApplicationSubmissionState();
}

Future<Map<String, dynamic>?> fetchCompanyInfo(String uid) async {
  final doc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  return doc.data();
}

class _ApplicationSubmissionState extends State<ApplicationSubmission> {
  Map<String, dynamic>? companyInfo;
  final uid = FirebaseAuth.instance.currentUser?.uid;
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
  void initState() {
    super.initState();
    fetchCompanyInfo(uid!).then((info) {
      setState(() {
        companyInfo = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold()
    );
  }
}
