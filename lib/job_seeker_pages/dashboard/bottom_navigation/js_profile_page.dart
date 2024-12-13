import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saat_recruitment/Firebase%20Services/resume_utils.dart';
import 'package:saat_recruitment/Services/cloud_storage.dart';
import 'package:saat_recruitment/Services/firestore_services.dart';
import 'package:saat_recruitment/login_page.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../Models/job_provider.dart';
import '../../../reusable_widgets/file_preview.dart';
import '../../../reusable_widgets/profile_pic.dart';
import '../../../reusable_widgets/reusable_widget.dart';

class JsProfilePage extends StatefulWidget {
  const JsProfilePage({super.key});

  @override
  State<JsProfilePage> createState() => _JsProfilePageState();
}

Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> fetchCompanyInfo(
    String uid) async {
  final doc =
      FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();
  return doc;
}

class _JsProfilePageState extends State<JsProfilePage> {
  TextEditingController nameController = TextEditingController();
  FilePickerResult? result;
  double _uploadProgress = 0;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? companyInfo;
  String selectedFileName = "";
  File? selectedFile;
  String _photoUrl = "";
  File? _profileImage;
  bool isLoading = false;
  FileUploadService fileUploadService = FileUploadService();

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
      allowedExtensions: ['pdf'],
    );
    if (result != null && result!.files.isNotEmpty) {
      PlatformFile file = result!.files.first;
      setState(() {
        selectedFileName = file.name;
        selectedFile = File(file.path!);
      });
      showPreviewModal(selectedFile, selectedFileName);
    }
  }

  void showPreviewModal(selectedFile, selectedFileName) {
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
                    onPressed: () async {
                      final resumeUrl = await fileUploadService.uploadResume(
                          selectedFile, uid!);
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(uid)
                          .update({
                        "resumeUrl": resumeUrl,
                        "resumeFileName": selectedFileName
                      });
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
              Expanded(child: getFilePreview(fileUrl, true,null)),
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

  @override
  void initState() {
    super.initState();
    _photoUrl = FirebaseAuth.instance.currentUser!.photoURL!;
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

  Widget displayCompanyInfo(
      Stream<DocumentSnapshot<Map<String, dynamic>>> companyInfo,
      BuildContext context,
      Function selectFile,
      File? selectedFile,
      String? selectedFileName,
      Function showPreviewModal,
      Function showPreviewModals) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, right: 10.0, left: 10),
      child: SingleChildScrollView(
        child: StreamBuilder(
            stream: companyInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('No company information available.');
              }
              final companyData = snapshot.data!.data() ?? {};

              return Column(
                children: [
                  ProfilePicWidget(
                    onImagePicked: (imageFile) async {
                      FileUploadService fileUploadService = FileUploadService();
                      FirestoreService firestoreService=FirestoreService();
                      try {
                        String profilePicUrl = await fileUploadService
                            .uploadProfilePic(imageFile, uid!);
                        firestoreService.uploadProfilePicUrl(uid, profilePicUrl);
                        // await FirebaseFirestore.instance
                        //     .collection("Users")
                        //     .doc(uid)
                        //     .update({
                        //   "profilePicUrl": profilePicUrl,
                        // });
                      } catch (e) {
                        print("Error uploading profile picture: $e");
                      }
                    },
                    uploadedProfileUrl: companyData['profilePicUrl'] ?? "",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: const Color(0xff1C4374),
                              width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              blurStyle: BlurStyle.outer,
                              color: Color(0xff1C4374),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Name: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1C4374)),
                            ),
                            SizedBox(
                              width: 220,
                              child: Text(
                                companyData['name'].toUpperCase() ?? "-----",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  final uid =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 50, horizontal: 20),
                                        child: Column(
                                          children: [
                                            textFormField(
                                              length: 20,
                                              "Enter Name to update",
                                              Icons.edit,
                                              false,
                                              onChanged: () {},
                                              keyboard: TextInputType.text,
                                              controller: nameController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please Enter Name";
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            CupertinoButton(
                                              color: const Color(0xff1C4374),
                                              onPressed: () {
                                                JobProviderModel.updateJpData(
                                                  uid,
                                                  {'Name': nameController.text},
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon:
                                    const Icon(Icons.edit, color: Colors.black))
                          ],
                        ),
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
                              width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              blurStyle: BlurStyle.outer,
                              color: Color(0xff1C4374),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 5, left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'E-mail: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff1C4374)),
                            ),
                            Text(
                              companyData['email'] ?? "-----",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black),
                            )
                          ],
                        ),
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
                              width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              blurStyle: BlurStyle.outer,
                              color: Color(0xff1C4374),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 5, left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Phone: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff1C4374)),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 220,
                                  child: Text(
                                    companyData['phone'] ?? "-----",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      final uid = FirebaseAuth
                                          .instance.currentUser?.uid;
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 50, horizontal: 20),
                                            child: Column(
                                              children: [
                                                textFormField(
                                                    "Enter Number to update",
                                                    Icons.edit,
                                                    false,
                                                    onChanged: () {},
                                                    keyboard:
                                                        TextInputType.number,
                                                    controller: nameController,
                                                    validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please Enter Number";
                                                  }
                                                  return null;
                                                }, length: 11),
                                                const SizedBox(height: 20),
                                                CupertinoButton(
                                                  color:
                                                      const Color(0xff1C4374),
                                                  onPressed: () {
                                                    JobProviderModel
                                                        .updateJpData(
                                                      uid,
                                                      {
                                                        'Phone':
                                                            nameController.text
                                                      },
                                                    );
                                                    Navigator.pop(context);
                                                    nameController.text = "";
                                                  },
                                                  child: const Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      color: Colors.black,
                                    ))
                              ],
                            )
                          ],
                        ),
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
                              width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              blurStyle: BlurStyle.outer,
                              color: Color(0xff1C4374),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 5, left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Gender: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1C4374)),
                            ),
                            Text(
                              companyData['gender'].toUpperCase() ?? "-----",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black),
                            )
                          ],
                        ),
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
                              width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              blurStyle: BlurStyle.outer,
                              color: Color(0xff1C4374),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Date of Birth: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff1C4374)),
                            ),
                            Text(
                              companyData['dob'].toUpperCase() ?? "-----",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            // IconButton(
                            //     onPressed: () {},
                            //     icon: const Icon(
                            //       Icons.edit,
                            //       color: Colors.black,
                            //     ))
                          ],
                        ),
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
                              width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              blurStyle: BlurStyle.outer,
                              color: Color(0xff1C4374),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Location: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff1C4374)),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                companyData['city'].toUpperCase() ?? "-----",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  final uid =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 50, horizontal: 20),
                                            child: Column(children: [
                                              textFormField("Enter Location",
                                                  Icons.edit, false,
                                                  onChanged: () {},
                                                  keyboard: TextInputType.text,
                                                  controller: nameController,
                                                  validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please Enter Your location";
                                                }
                                                return null;
                                              }),
                                              const SizedBox(height: 20),
                                              CupertinoButton(
                                                color: const Color(0xff1C4374),
                                                onPressed: () {
                                                  JobProviderModel.updateJpData(
                                                    uid,
                                                    {
                                                      'Location':
                                                          nameController.text
                                                    },
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ]));
                                      });
                                },
                                icon: const Icon(Icons.edit_location,
                                    color: Colors.black))
                          ],
                        ),
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
                              width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              blurStyle: BlurStyle.outer,
                              color: Color(0xff1C4374),
                            )
                          ]),
                      child: InkWell(
                        child: const Padding(
                          padding:
                              EdgeInsets.only(top: 5.0, bottom: 5, left: 8.0),
                          child: Row(
                            children: [
                              Text(
                                'Privacy & Security',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
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
                              width: 1.5),
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
                                    fontWeight: FontWeight.w800, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  InkWell(
                                    child: SizedBox(
                                      width: 300,
                                      child: companyData['resumeFileName'] == ""
                                          ? const Text(
                                              "TAP TO UPLOAD YOUR CV",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w900),
                                            )
                                          : Text(
                                              companyData['resumeFileName'],
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                            ),
                                    ),
                                    onTap: () async {
                                      companyData['resumeFileName'] == ""
                                          ? selectFile()
                                          : showPreviewModals(
                                              companyData['resumeUrl']);
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
                            width: 1.5),
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
                                  fontSize: 18, fontWeight: FontWeight.w800),
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
                ],
              );
            }),
      ),
    );
  }
}
