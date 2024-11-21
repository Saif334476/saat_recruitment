import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Firebase%20Services/resume_utils.dart';
import 'package:saat_recruitment/login_page.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class JsProfilePage extends StatefulWidget {
  const JsProfilePage({super.key});

  @override
  State<JsProfilePage> createState() => _JsProfilePageState();
}

Future<Map<String, dynamic>?> fetchCompanyInfo(String uid) async {
  final doc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  return doc.data();
}

class _JsProfilePageState extends State<JsProfilePage> {
  FilePickerResult? result;
  double _uploadProgress = 0;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Map<String, dynamic>? companyInfo;
  String selectedFileName = "";
  File? selectedFile;

  Future<void> _uploadResume(File selectedFile, String selectedFileName) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    _showUploadDialog();
    try {
      final newResumeUrl = await ResumeUtils().uploadFileToStorage(
          selectedFile, selectedFileName, (double progress) {
        setState(() {
          _uploadProgress = progress;
          print('Progress: $progress');
        });
      });

      await ResumeUtils()
          .saveResumeToFirestore(uid, newResumeUrl, selectedFileName);

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors
      Navigator.pop(context);
      print('Error uploading file: $e');
    }
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressLoader(progress: _uploadProgress),
    );
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
      showPreviewModal(selectedFile);
    }
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
                selectedFileName,
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
                      setState(() {
                        _uploadResume(selectedFile, selectedFileName);
                      });
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
              Expanded(child: _getFilePreview(fileUrl)),
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
      return SfPdfViewer.network(fileUrl);
    } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension)) {
      try {
        return Image.network(fileUrl);
      } catch (e) {
        return Text(
          'Error loading image: $e',
          style: const TextStyle(fontSize: 18),
        );
      }
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
      body: companyInfo != null
          ? displayCompanyInfo(companyInfo!, context, selectFile, selectedFile,
              selectedFileName, showPreviewModal, showPreviewModals)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

Widget displayCompanyInfo(
    Map<String, dynamic> companyInfo,
    BuildContext context,
    Function selectFile,
    File? selectedFile,
    String? selectedFileName,
    Function showPreviewModal,
    Function showPreviewModals) {
  return Padding(
    padding: const EdgeInsets.only(right: 20.0, left: 20),
    child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xff1C4374), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff1C4374).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    height: 120,
                    width: 120,
                    FirebaseAuth.instance.currentUser!.photoURL.toString(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 85,
                right: 0,
                left: 85,
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xff1C4374)),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: const Color(0xff1C4374),
                          width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Color(0xff1C4374),
                        )
                      ]),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Name: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff1C4374)),
                          ),
                          Text(
                            companyInfo['Name'].toUpperCase() ?? "-----",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit, color: Colors.black))
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: const Color(0xff1C4374),
                          width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Color(0xff1C4374),
                        )
                      ]),
                  child: InkWell(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5.0, bottom: 5, left: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'E-mail: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff1C4374)),
                          ),
                          Text(
                            companyInfo['Email'] ?? "-----",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: const Color(0xff1C4374),
                          width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Color(0xff1C4374),
                        )
                      ]),
                  child: InkWell(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5.0, bottom: 5, left: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Phone: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff1C4374)),
                          ),
                          Row(
                            children: [
                              Text(
                                companyInfo['Phone'] ?? "-----",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.phone_android_outlined))
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: const Color(0xff1C4374),
                          width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Color(0xff1C4374),
                        )
                      ]),
                  child: InkWell(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5.0, bottom: 5, left: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Gender: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff1C4374)),
                          ),
                          Text(
                            companyInfo['Gender'].toUpperCase() ?? "-----",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: const Color(0xff1C4374),
                          width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Color(0xff1C4374),
                        )
                      ]),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Date of Birth: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff1C4374)),
                          ),
                          Text(
                            companyInfo['Dob'].toUpperCase() ?? "-----",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ))
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: const Color(0xff1C4374),
                          width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Color(0xff1C4374),
                        )
                      ]),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Location: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff1C4374)),
                          ),
                          Text(
                            companyInfo['Location'].toUpperCase() ?? "-----",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit_location,
                                  color: Colors.black))
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: const Color(0xff1C4374),
                          width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Color(0xff1C4374),
                        )
                      ]),
                  child: InkWell(
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5, left: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Privacy & Security',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      // Handle item 1 tap
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: const Color(0xff1C4374),
                          width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Color(0xff1C4374),
                        )
                      ]),
                  child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 2),
                          child: Text(
                            "Resume/CV",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              InkWell(
                                child: SizedBox(
                                  width: 200,
                                  child: companyInfo['resumeFileName'] == ""
                                      ? const Text(
                                          "TAP TO UPLOAD YOUR CV",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900),
                                        )
                                      : Text(
                                          companyInfo['resumeFileName'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                ),
                                onTap: () async {
                                  companyInfo['resumeFileName'] == ""
                                      ? selectFile()
                                      : showPreviewModals(
                                          companyInfo['resumeUrl']);
                                },
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     selectFile(companyInfo['resumeUrl']);
                              //   },
                              //   icon: const Icon(Icons.edit),
                              // )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: const Color(0xff1C4374),
                        width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        blurStyle: BlurStyle.outer,
                        color: Color(0xff1C4374),
                      )
                    ]),
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.logout_outlined,
                              color: Colors.black,
                            )),
                        const Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                ),
              ),

              // Add more fields as needed
            ],
          ),
        ],
      ),
    ),
  );
}
