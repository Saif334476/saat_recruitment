import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'jp_doc_review_submission.dart';

class JpUploadDocument extends StatefulWidget {
  final String name;
  final String location;
  final String? industry;
  final String email;
  final String? companySize;

  const JpUploadDocument(
      {super.key,
      required this.name,
      required this.location,
      required this.industry,
      required this.email,
      required this.companySize});

  @override
  JpUploadDocumentState createState() => JpUploadDocumentState();
}

class JpUploadDocumentState extends State<JpUploadDocument> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDocumentType;
  late File _uploadedDocument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     'Company Verification',
      //     style: TextStyle(fontWeight: FontWeight.w900),
      //   ),
      //   backgroundColor: const Color(0xff1C4374),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
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
                                name: widget.name,
                                location: widget.location,
                                industry: widget.industry,
                                email: widget.email,
                                companySize: widget.companySize,
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

  const FileUploadButton({
    super.key,
    required this.onFileSelected,
  });

  @override
  State<FileUploadButton> createState() => _FileUploadButtonState();
}

class _FileUploadButtonState extends State<FileUploadButton> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
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
          final  FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
            );
            if ( result!.files.isNotEmpty) {
              final PlatformFile file = result.files.first;
              await Future.delayed(const Duration(seconds: 0));
              final File convertedFile = File(file.path!);
              setState(() {
                _uploadedDocument = convertedFile;
                _selectedFileName = file.name.toString();
                _isFileSelected = true;
              });
             widget.onFileSelected(convertedFile);
              // final storageRef = FirebaseStorage.instance.ref(
              //     'LegalDocs/${DateTime.now().millisecondsSinceEpoch}.jpeg');
              // final uploadTask = storageRef.putFile(_uploadedDocument!);
              // final downloadUrl = await (await uploadTask).ref.getDownloadURL();
              // await FirebaseFirestore.instance
              //     .collection('JobProviders')
              //     .doc(FirebaseAuth.instance.currentUser?.uid)
              //     .set({
              //   'documents': downloadUrl,
              //   'documentFileName': file.name,
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

        (_isFileSelected==false)? const Text(
            'Please upload a document',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.w700, fontSize: 20),
          ):
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.file_present,color: Colors.lightBlue,),
              const SizedBox(width: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
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
            ],
          ),
      ],
    );
  }
}
