import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saat_recruitment/login_page.dart';
import 'package:saat_recruitment/reusable_widgets/profile_pic.dart';
import '../../../Models/job_provider.dart';
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
  File? _profileImage;
  String? _photoUrl;
  bool isLoading = false;
  File? profilePicFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        isLoading = true;
      });

      await _uploadImageToFirebase(pickedFile);
    }
  }

  Future<void> _uploadImageToFirebase(XFile pickedFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pics/$fileName');

      UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      if (mounted) {
        await _updateProfilePhoto(downloadUrl);
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _updateProfilePhoto(String downloadUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePhotoURL(downloadUrl);

        if (mounted) {
          setState(() {
            _photoUrl = downloadUrl;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error updating profile photo URL: $e');
    }
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

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> fetchCompanyInfo(
      String uid) async {
    final doc =
        FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();
    return doc;
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
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ProfilePicWidget(
                  onImagePicked: (imageUrl) {
                    setState(() {
                      profilePicFile=imageUrl;
                    });
                  },uploadedProfileUrl: "",
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, right: 20, left: 20),
                  child: Container(
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
                    child: ListTile(
                      title: Row(
                        children: [
                          const Text(
                            'Name: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff1C4374)),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              companyData['Name'].toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color(0xff1C4374),
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
                                            "Enter value to Update",
                                            Icons.edit,
                                            false,
                                            onChanged: () {},
                                            keyboard: TextInputType.text,
                                            controller: nameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                              icon: const Icon(Icons.edit, color: Colors.black))
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, right: 20.0, left: 20),
                  child: Container(
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
                    child: ListTile(
                      title: Row(
                        children: [
                          const Text(
                            'E-mail: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff1C4374)),
                          ),
                          Text(
                            companyData['Email'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Color(0xff1C4374)),
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 20, left: 20),
                  child: Container(
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
                    child: ListTile(
                      title: Row(
                        children: [
                          const Text(
                            'Industry: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff1C4374)),
                          ),
                          Text(
                            companyData['Industry'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Color(0xff1C4374)),
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 20, left: 20),
                  child: Container(
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
                    child: ListTile(
                      title: Row(
                        children: [
                          const Text(
                            'Location: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff1C4374)),
                          ),
                          SizedBox(
                            width: 160,
                            child: Text(
                              companyData['Location'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color(0xff1C4374),
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
                                            "Enter value to Update",
                                            Icons.edit,
                                            false,
                                            onChanged: () {},
                                            keyboard: TextInputType.text,
                                            controller: nameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                              icon: const Icon(Icons.edit_location,
                                  color: Colors.black))
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 20, left: 20),
                  child: Container(
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
                    child: ListTile(
                      title: Row(
                        children: [
                          const Text(
                            'Company Size: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff1C4374)),
                          ),
                          SizedBox(
                            width: 110,
                            child: Text(
                              companyData['CompanySize'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color(0xff1C4374),
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
                                            "Enter value to Update",
                                            Icons.edit,
                                            false,
                                            onChanged: () {},
                                            keyboard: TextInputType.text,
                                            controller: nameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                                {
                                                  'CompanySize':
                                                      nameController.text
                                                },
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
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ))
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 20, left: 20),
                  child: Container(
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
                    child: ListTile(
                      title: const Text(
                        'Privacy & Security',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      onTap: () {
                        // Handle item 1 tap
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 20, left: 20),
                  child: Container(
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
                    child: ListTile(
                      title: Row(
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
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    ),
                  ),
                ),

                // Add more fields as needed
              ],
            ),
          );
        });
  }
}
