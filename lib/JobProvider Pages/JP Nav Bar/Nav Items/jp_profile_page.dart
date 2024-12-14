import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saat_recruitment/Services/cloud_storage.dart';
import 'package:saat_recruitment/Services/firestore_services.dart';
import 'package:saat_recruitment/login_page.dart';
import 'package:saat_recruitment/reusable_widgets/profile_pic.dart';
import '../../../Models/job_provider.dart';
import '../../../reusable_widgets/list_tile.dart';
import '../../../reusable_widgets/reusable_widget.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

Future<Map<String, dynamic>?> fetchCompanyInfo(String uid) async {
  final doc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  return doc.data();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  TextEditingController nameController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? companyInfo;
  String? _photoUrl;
  bool isLoading = false;
  File? profilePicFile;
  final ImagePicker _picker = ImagePicker();

  // Future<void> _pickImage() async {
  //   final XFile? pickedFile =
  //       await _picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImage = File(pickedFile.path);
  //       isLoading = true;
  //     });
  //
  //     await _uploadImageToFirebase(pickedFile);
  //   }
  // }

  // Future<void> _uploadImageToFirebase(XFile pickedFile) async {
  //   try {
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //     Reference storageReference =
  //         FirebaseStorage.instance.ref().child('profile_pics/$fileName');
  //
  //     UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));
  //
  //     TaskSnapshot snapshot = await uploadTask;
  //
  //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //
  //     if (mounted) {
  //       await _updateProfilePhoto(downloadUrl);
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }
  // }

  // Future<void> _updateProfilePhoto(String downloadUrl) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //
  //     if (user != null) {
  //       await user.updatePhotoURL(downloadUrl);
  //
  //       if (mounted) {
  //         setState(() {
  //           _photoUrl = downloadUrl;
  //           isLoading = false;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print('Error updating profile photo URL: $e');
  //   }
  // }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> fetchCompanyInfo(
      String uid) async {
    final doc =
        FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();
    return doc;
  }
void _saveNewPhoto()async{
  FirestoreService firestoreService=FirestoreService();
  FileUploadService fileUploadService=FileUploadService();
  final profilePicUrl=await fileUploadService.uploadProfilePic(profilePicFile!, uid!);
  await firestoreService.uploadProfilePicUrl(uid, profilePicUrl);
}
  @override
  void initState() {
    super.initState();
    _photoUrl = FirebaseAuth.instance.currentUser?.photoURL;
    fetchCompanyInfo(uid!).then((info) {
      setState(() {
        companyInfo = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: companyInfo != null
            ? displayCompanyInfo(
                companyInfo!,
                context,
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget displayCompanyInfo(
    Stream<DocumentSnapshot<Map<String, dynamic>>> companyData,
    BuildContext context,
  ) {
    return StreamBuilder(
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

          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                ProfilePicWidget(
                  onImagePicked: (imageUrl) {

                    setState(() {
                      profilePicFile = imageUrl;
                    });
                  _saveNewPhoto();

                  },
                  uploadedProfileUrl: companyData['profilePicUrl'],
                ),

                buildListTile(
                  context,
                  "Name: ",
                  companyData['Name'],
                  Icons.edit_rounded,
                  () {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 50, horizontal: 20),
                          child: Column(
                            children: [
                              textFormField(
                                "Enter value to Update",
                                Icons.edit,
                                false,
                                onChanged: () {},
                                keyboard: TextInputType.text,
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter text";
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
                ),

                buildListTile(context, "E-mail: ", companyData['Email'], null,
                    () async {}),
                buildListTile(context, "Industry: ", companyData['Industry'],
                    null, () async {}),

                buildListTile(
                  context,
                  "Location: ",
                  companyData['Location'],
                  Icons.edit_rounded,
                  () {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 50, horizontal: 20),
                          child: Column(
                            children: [
                              textFormField(
                                "Enter value to Update",
                                Icons.edit,
                                false,
                                onChanged: () {},
                                keyboard: TextInputType.text,
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter text";
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
                                    {'Location': nameController.text},
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
                ),

                buildListTile(
                  context,
                  "Company Size: ",
                  companyData['companySize'],
                  Icons.edit,
                  () {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 50, horizontal: 20),
                          child: Column(
                            children: [
                              textFormField(
                                "Enter value to Update",
                                Icons.edit,
                                false,
                                onChanged: () {},
                                keyboard: TextInputType.text,
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter text";
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
                                    {'CompanySize': nameController.text},
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
                ),
                buildListTile(
                    context, "Privacy & Security", "", null, () async {}),
                buildListTile(context, "Logout", "", Icons.logout_outlined,
                    () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }),
                // Add more fields as needed
              ],
            ),
          );
        });
  }
}
