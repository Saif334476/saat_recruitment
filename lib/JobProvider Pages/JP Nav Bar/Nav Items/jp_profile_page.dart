import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/login_page.dart';

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
  Map<String, dynamic>? companyInfo;

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
    Map<String, dynamic> companyInfo,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
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
          Padding(
            padding: const EdgeInsets.only(top: 50.0, right: 20, left: 20),
            child: Container(
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
                        companyInfo['Name'].toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xff1C4374),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
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
                        icon: const Icon(Icons.edit, color: Colors.black))
                  ],
                ),
                onTap: () {},
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20.0, left: 20),
            child: Container(
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
                      companyInfo['Email'],
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
            padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
            child: Container(
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
                      companyInfo['Industry'],
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
            padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
            child: Container(
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
                        companyInfo['Location'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xff1C4374),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
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
                        icon: const Icon(Icons.edit_location,
                            color: Colors.black))
                  ],
                ),
                onTap: () {},
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
            child: Container(
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
                      width: 100,
                      child: Text(
                        companyInfo['CompanySize'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xff1C4374),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
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
            padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
            child: Container(
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
              child: ListTile(
                title: const Text(
                  'Privacy & Security',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  // Handle item 1 tap
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
            child: Container(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
  }
}
