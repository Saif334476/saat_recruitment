import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Map<String, dynamic>? companyInfo;
  String? selectedFileName;
  File? selectedFile;

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFile = File(result.files.first.path!);
      });
      showPreviewModal();
    }
  }

  void updateFileOnFirestoreAndStorage() async {
    if (selectedFile != null) {
      await FirebaseFirestore.instance
          .collection('JobProviders')
          .doc(uid)
          .update({
        'resumeFileUrl': await _uploadFileToStorage(selectedFile!),
        'resumeFileName': selectedFileName,
      });
    }
  }

  Future<String> _uploadFileToStorage(File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child('resumes/$selectedFileName');
    final uploadTask = fileRef.putFile(file);
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  void showPreviewModal() {
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      updateFileOnFirestoreAndStorage();
                    },
                    child: const Text('OK'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectFile();
                      //  showPreviewModal();
                    },
                    child: const Text('Update'),
                  )
                ],
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
  return Container(
    decoration: const BoxDecoration(
      //   gradient: LinearGradient(
      //       colors: [Colors.blue, Colors.white],
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter),
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: SizedBox(
              height: 120,
              width: 120,
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  child: Image.asset(
                      FirebaseAuth.instance.currentUser!.photoURL.toString())),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: InkWell(
                  child: Row(
                    children: [
                      const Divider(
                        height: 5,
                      ),
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
                  onTap: () {},
                ),
              ),
              const Divider(
                height: 5,
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0,bottom: 5),
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
              const Divider(
                height: 5,
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0,bottom: 5),
                  child: Row(
                    children: [
                      const Text(
                        'Phone: ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff1C4374)),
                      ),
                      Text(
                        companyInfo['Phone'] ?? "-----",
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
              const Divider(
                height: 5,
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0,bottom: 5),
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
              const Divider(
                height: 5,
              ),
              InkWell(
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
                onTap: () {},
              ),
              const Divider(
                height: 5,
              ),
              InkWell(
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
                onTap: () {},
              ),

              const Divider(
                height: 5,
              ),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.only(top: 5.0,bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        'Privacy & Security',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,),textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Handle item 1 tap
                },
              ),
              const Divider(
                height: 15,
              ),
              InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Resume/CV",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              companyInfo['resumeFileName'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          onTap: () async {
                            showPreviewModals(companyInfo['resumeUrl']);
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            selectFile();
                          },
                          icon: const Icon(Icons.edit),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 5,
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0,bottom: 5),
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
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
              const Divider(
                height: 5,
              ),
              // Add more fields as needed
            ],
          ),
        ],
      ),
    ),
  );
}
