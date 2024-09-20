import 'dart:io';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:saat_recruitment/company_pages/company_verification_page.dart';

class CompanyVerificationPage extends StatefulWidget {
  const CompanyVerificationPage({super.key});

  @override
  CompanyVerificationPageState createState() => CompanyVerificationPageState();
}

class CompanyVerificationPageState extends State<CompanyVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDocumentType;
  late File _uploadedDocument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Company Verification',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: 130, child: Image.asset("assets/uploadfile.webp")),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'To ensure the authenticity of our platform, we require all companies to provide legal documentation to verify their identity and industry affiliation.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Please select the type of document you want to upload:',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(color: Colors.red),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Document Type',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'tax_certificate',
                          child: Text('Tax Certificate'),
                        ),
                        DropdownMenuItem(
                          value: 'registration_form',
                          child: Text('Registration Form'),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text('Other'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedDocumentType = value!;
                        });
                      },
                      validator: (value) {
                        if (_selectedDocumentType == null ||
                            _selectedDocumentType == "Company Size") {
                          return 'Please select document Type';
                        }
                        return null;
                      },
                      value: _selectedDocumentType,
                    ),
                    const SizedBox(height: 30),
                    FileUploadButton(
                      onFileSelected: (file) {
                        setState(() {
                          _uploadedDocument = file;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton(
                      color: const Color(0xff1C4374),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_uploadedDocument.path.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please upload a file'),
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewAndSubmitPage(
                                uploadedDocument: _uploadedDocument,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FileUploadButton extends StatefulWidget {
  final Function(File) onFileSelected;

  const FileUploadButton({super.key, required this.onFileSelected});

  @override
  State<FileUploadButton> createState() => _FileUploadButtonState();
}

class _FileUploadButtonState extends State<FileUploadButton> {
  File? _uploadedDocument;
  bool _isFileSelected = false;
  String? _selectedFileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
          color: Colors.transparent,
          onPressed: () async {
            final FilePickerResult? result =
                await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'jpg', 'png'],
            );
            if (result != null && result.files.isNotEmpty) {
              final PlatformFile file = result.files.first;
              await Future.delayed(const Duration(seconds: 0));
              if (file.size > 1024 * 1024 * 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File size exceeds 5MB limit'),
                  ),
                );
                return;
              }
              final File convertedFile = File(file.path!);
              setState(() {
                _uploadedDocument = convertedFile;
                _selectedFileName = file.name;
                _isFileSelected = true;
              });
               widget.onFileSelected(convertedFile);

              // final storageRef = FirebaseStorage.instance
              //     .ref('LegalDocs/${DateTime.now().millisecondsSinceEpoch}.jpeg');
              // final uploadTask = storageRef.putFile(_uploadedDocument!);
              // final downloadUrl = await (await uploadTask).ref.getDownloadURL();
              // await FirebaseFirestore.instance
              //     .collection('JobProviders')
              //     .doc(FirebaseAuth.instance.currentUser?.uid)
              //     .set({
              //   'resumeUrl': downloadUrl,
              //   'resumeFileName': file.name,
              // });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No file selected'),
                ),
              );
            }
          },
          child: const Icon(
            Icons.upload_file_outlined,
            size: 75,
            color: Color(0xff559BD4),
          ),
        ),
        if (_uploadedDocument == null)
          const Text(
            'Please upload a document',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.w700, fontSize: 20),
          ),
        if (_isFileSelected)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.file_present),
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
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
