import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadCvResume extends StatefulWidget {
  const UploadCvResume({super.key});

  @override
  State<UploadCvResume> createState() => _UploadCvResumeState();
}

class _UploadCvResumeState extends State<UploadCvResume> {
  File? convertedFile;
  FilePickerResult? result;
  String? _selectedFileName;
  bool _isFileSelected = false;
  final uId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload CV/Resume",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff193d67),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 200.0, left: 20, right: 20),
                child: Text(
                  "You don't have Uploaded your CV/Resume yet,Please tap the icon below to continue application",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w700),textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: IconButton(
                    onPressed: () async {
                      result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'jpg', 'jpeg'],
                      );
                      if (result != null && result!.files.isNotEmpty) {
                        PlatformFile file = result!.files.first;
                        setState(() {
                          _selectedFileName = file.name;
                          _isFileSelected = true;
                          convertedFile = File(file.path!);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.file_upload_outlined,
                      size: 100,
                      color: Colors.lightBlue,
                    )),
              ),
              if (_isFileSelected)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.file_present,color: Colors.lightBlue,),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Expanded(
                            child: Text(
                              _selectedFileName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1, // Limit to 3 lines
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CupertinoButton(
                          color: const Color(0xff193d67),
                          child: const Text(
                            "Upload & Submit",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                          onPressed: () async {
                            String? resumeUrl;
                            if (_isFileSelected) {
                              final storageRef = FirebaseStorage.instance
                                  .ref('resumes/$uId.jpeg');
                              final uploadTask =
                                  storageRef.putFile(convertedFile!);
                              resumeUrl =
                                  await (await uploadTask).ref.getDownloadURL();

                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(uId)
                                  .update({
                                'resumeUrl': resumeUrl,
                                'resumeFileName': _selectedFileName ?? "",
                              });
                            }
                            Navigator.pop(context);
                          }),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
