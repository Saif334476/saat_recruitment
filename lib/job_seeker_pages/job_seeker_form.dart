import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Services/firestore_services.dart';
import 'package:saat_recruitment/job_seeker_pages/Resume_Preview.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/bottom_navigation/js_bottom_nav_bar.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'package:intl/intl.dart';
import '../Models/job_seeker_model.dart';
import '../Services/cloud_storage.dart';
import '../reusable_widgets/profile_pic.dart';

class JobSeekerProfile extends StatefulWidget {
  const JobSeekerProfile({super.key});
  @override
  JobSeekerProfileState createState() => JobSeekerProfileState();
}

class JobSeekerProfileState extends State<JobSeekerProfile> {
  File? profilePicFile;
  File? cvFile;
  FilePickerResult? result;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _city = TextEditingController();
  String _gender = "Male";
  String _selectedFileName = "";
  bool _isFileSelected = false;
  String? _credentials;
  String _profilePicUrl = "";
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final _userEmail = FirebaseAuth.instance.currentUser?.email;
  final _userPhone = FirebaseAuth.instance.currentUser?.phoneNumber;

  _fetchCredentials() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();
    if (snapshot.exists) {
      setState(() {
        _credentials = snapshot.get("accountCreatedWith");
      });
    } else {
      throw Exception("User not found");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCredentials();
    if (_userEmail != null) {
      _email.text = _userEmail;
    }
    if (_userPhone != null) {
      _phoneNumber.text = _userPhone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding:
          const EdgeInsets.only(top: 60.0, left: 20, right: 20, bottom: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProfilePicWidget(
              onImagePicked: (imageUrl) {
                setState(() {
                  profilePicFile=imageUrl;
                });
              },uploadedProfileUrl: "",
            ),
            Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: textFormField(
                              keyboard: TextInputType.text,
                              onChanged: () {
                                setState(() {});
                              },
                              "Enter Your Name",
                              Icons.person,
                              false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Your Name';
                                } else {
                                  return null;
                                }
                              },
                              controller: _name)),
                      _credentials != "phone"
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: textFormField(
                                  keyboard: TextInputType.number,
                                  onChanged: () {
                                    setState(() {});
                                  },
                                  "Enter Phone Number",
                                  Icons.phone_android_outlined,
                                  false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Your Phone Number';
                                    }
                                    return null;
                                  },
                                  controller: _phoneNumber))
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xff1C4374)),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    labelText: "Your Phone",
                                    prefixIcon:
                                        const Icon(Icons.email_outlined)),
                                initialValue: _phoneNumber.text,
                                readOnly: true,
                              ),
                            ),
                      _credentials != "email"
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: textFormField(
                                  keyboard: TextInputType.text,
                                  onChanged: () {
                                    setState(() {});
                                  },
                                  "Enter Your E-mail",
                                  Icons.email,
                                  false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Your E-mail';
                                    }
                                    return null.toString();
                                  },
                                  controller: _email))
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xff1C4374)),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    labelText: "Your E-mail",
                                    prefixIcon:
                                        const Icon(Icons.email_outlined)),
                                initialValue: _email.text,
                                readOnly: true,
                              ),
                            ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: dropDown(
                            isEditing: false,
                            value: _gender,
                            icon: Icons.person_add,
                            validator: (value) {
                              if (value == null) {
                                return 'Select Your Gender';
                              }
                              return null;
                            },
                            text: 'Gender',
                            items: ['Male', 'Female', 'Other'].map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          readOnly: true,
                          controller: _dateController,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            ).then((pickedDate) {
                              if (pickedDate != null) {
                                _dateController.text =
                                    DateFormat.yMd().format(pickedDate);
                              }
                            });
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(15)),
                              labelText: 'Date of Birth',
                              prefixIcon: const Icon(
                                Icons.calendar_today_outlined,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      placesAutoCompleteTextField(_city),
                      IconButton(
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
                              cvFile = File(file.path!);
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResumePreview(
                                        selectedFile: cvFile!,
                                        selectedFileName: _selectedFileName)));
                          }
                        },
                        icon: const Icon(
                          Icons.file_upload_outlined,
                          size: 50,
                          color: Colors.lightBlue,
                        ),
                      ),
                      const Text('CV/Resume',
                          style: TextStyle(shadows: [
                            BoxShadow(
                                blurStyle: BlurStyle.outer,
                                blurRadius: 2,
                                offset: Offset(0, .5))
                          ], fontSize: 18, fontWeight: FontWeight.w600)),
                      if (_isFileSelected)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.file_present,
                              color: Colors.lightBlue,
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                _selectedFileName,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: CupertinoButton(
                            color: const Color(0xff1C4374),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _uploadJobSeekerData();

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const JsBottomNavigationBar(),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "CREATE  PROFILE",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 21,
                                  color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    ));
  }

  void _uploadJobSeekerData() async {
    String profilePicUrl = "";
    String resumeUrl = "";
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FileUploadService fileUploadService = FileUploadService();
    FirestoreService firestoreService = FirestoreService();
    if (profilePicFile != null) {
      profilePicUrl = await fileUploadService.uploadProfilePic(profilePicFile!, uid);
    }
    if (cvFile != null) {
      resumeUrl = await fileUploadService.uploadResume(cvFile!, uid);
    }
    JobSeeker jobSeeker = JobSeeker(
      name: _name.text,
      email: _email.text,
      phone: _phoneNumber.text,
      gender: _gender,
      dob: _dateController.text,
      city: _city.text,
      profilePicUrl: profilePicUrl,
      cvFileName: _selectedFileName,
      resumeUrl: resumeUrl,
    );
    await firestoreService.saveJobSeekerData(uid, jobSeeker.toMap());
    await FirebaseFirestore.instance.collection("Users").doc(uid).update({"isComplete":true});
  }
}
