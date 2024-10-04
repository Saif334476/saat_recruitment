import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/job_seeker_dashboard.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'package:intl/intl.dart';

class JobSeekerProfile extends StatefulWidget {
  final String? email;
  final String? credentials;
  final String? emailController;
  final String? uId;
  const JobSeekerProfile(
      this.email, this.credentials, this.emailController, this.uId,
      {super.key});
  @override
  JobSeekerProfileState createState() => JobSeekerProfileState();
}

class JobSeekerProfileState extends State<JobSeekerProfile> {
  File? convertedFile;

  FilePickerResult? result;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  String _city = "Lahore";
  String _gender = "Male";
  String? _selectedFileName;
  bool _isFileSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue],
                begin: Alignment(0.78, 0),
                end: Alignment(0.78, 0.77),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 75.0, left: 20, right: 20),
                child: Column(children: [
                  const Text("PROFILE CREATION",
                      textAlign: TextAlign.center,
                      style: TextStyle(shadows: [
                        BoxShadow(
                            blurStyle: BlurStyle.outer,
                            blurRadius: 3,
                            offset: Offset(0, 1.59))
                      ], fontWeight: FontWeight.w900, fontSize: 35)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
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

                            Padding(
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
                                    controller: _phoneNumber)),

                            // widget.credentials != "phone"
                            //     ? Padding(
                            //         padding:
                            //             const EdgeInsets.only(top: 10),
                            //         child: textFormField(
                            //             keyboard: TextInputType.number,
                            //             onChanged: () {
                            //               setState(() {});
                            //             },
                            //             "Enter Phone Number",
                            //             Icons.phone_android_outlined,
                            //             false,
                            //             validator: (value) {
                            //               if (value!.isEmpty) {
                            //                 return 'Enter Your Phone Number';
                            //               }
                            //               return null.toString();
                            //             },
                            //             controller: _phoneNumber))
                            //     : Padding(
                            //         padding: const EdgeInsets.only(
                            //             top: 10.0),
                            //         child: TextFormField(
                            //           decoration: InputDecoration(
                            //               errorBorder:
                            //                   OutlineInputBorder(
                            //                       borderSide:
                            //                           const BorderSide(
                            //                               color:
                            //                                   Colors
                            //                                       .red),
                            //                       borderRadius:
                            //                           BorderRadius
                            //                               .circular(
                            //                                   15)),
                            //               border: OutlineInputBorder(
                            //                   borderSide:
                            //                       const BorderSide(
                            //                           color: Color(
                            //                               0xff1C4374)),
                            //                   borderRadius:
                            //                       BorderRadius.circular(
                            //                           15)),
                            //               labelText: "Your Phone",
                            //               prefixIcon: const Icon(
                            //                   Icons.email_outlined)),
                            //           initialValue: widget.phone,
                            //           readOnly: true,
                            //         ),
                            //       ),
                            widget.credentials != "email"
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
                                        controller: _email
                                        // ..text = widget.lEmail.text
                                        ))
                                : Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xff1C4374)),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          labelText: "Your Email",
                                          prefixIcon:
                                              const Icon(Icons.email_outlined)),
                                      initialValue: widget.emailController,
                                      readOnly: true,
                                    ),
                                  ),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: dropDown(
                                  value: _gender,
                                  icon: Icons.person_add,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Select Your Gender';
                                    }
                                    return null;
                                  },
                                  text: 'Gender',
                                  items:
                                      ['Male', 'Female', 'Other'].map((gender) {
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
                                        borderSide: const BorderSide(
                                            color: Colors.black12),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    labelText: 'Date of Birth',
                                    prefixIcon: const Icon(
                                      Icons.calendar_today_outlined,
                                    )),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: dropDown(
                                  value: _city,
                                  icon: Icons.location_on_outlined,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Select Your City';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _city = value;
                                    });
                                  },
                                  onSaved: (value) {
                                    _city = value;
                                  },
                                  text: 'Location',
                                  items: [
                                    'Karachi',
                                    'Lahore',
                                    'Faisalabad',
                                    'Rawalpindi',
                                    'Multan',
                                    'Gujranwala',
                                    'Hyderabad',
                                    'Peshawar',
                                    'Islamabad',
                                    'Quetta',
                                    'Sargodha',
                                    'Sialkot',
                                    'Bahawalpur',
                                    'Sukkur',
                                    'Gujrat',
                                    'Sahiwal',
                                    'Okara',
                                    'Jhang',
                                    'D.G Khan',
                                    'Chiniot',
                                    'Jehlum',
                                    'Khanewal',
                                    'Kohat',
                                    'Bawalnagar',
                                    'Chakwal',
                                    'Mianwali'
                                  ].map((city) {
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                )),
                            // const Padding(
                            //   padding: EdgeInsets.only(top: 10.0),
                            //   child: Divider(height: 20,thickness: 3.5,),
                            // ),
                            const Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Text('UPLOAD CV/RESUME',
                                  style: TextStyle(
                                      shadows: [
                                        BoxShadow(
                                            blurStyle: BlurStyle.outer,
                                            blurRadius: 2,
                                            offset: Offset(0, .5))
                                      ],
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800)),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0, top: 1.0),
                              child: Text(
                                "File's size must be 5MBs or smaller",
                                style: TextStyle(
                                    // shadows: [
                                    //   BoxShadow(
                                    //       blurStyle: BlurStyle.outer,
                                    //       blurRadius: 2,
                                    //       offset: Offset(0, .5))
                                    // ],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: CupertinoButton(
                                color: const Color(0xff1C4374),
                                onPressed: () async {
                                  result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf', 'doc', 'docx'],
                                  );
                                  if (result != null &&
                                      result!.files.isNotEmpty) {
                                    PlatformFile file = result!.files.first;
                                    setState(() {
                                      _selectedFileName = file.name;
                                      _isFileSelected = true;
                                      convertedFile = File(file.path!);
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.upload_file_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (_isFileSelected)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.file_present),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: CupertinoButton(
                                  color: const Color(0xff1C4374),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _saveJobSeekerData();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NHomePage(),
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
                  ),
                ]),
              ),
            )));
  }

  void _saveJobSeekerData() async {
    try {
      String? resumeUrl;
      if (_isFileSelected) {
        final storageRef = FirebaseStorage.instance
            .ref('resumes/${DateTime.now().millisecondsSinceEpoch}.jpeg');
        final uploadTask = storageRef.putFile(convertedFile!);
        resumeUrl = await (await uploadTask).ref.getDownloadURL();
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uId)
          .set({
        'Name': _name.text,
        'Phone': _phoneNumber.text,
        'Email': widget.email,
        'Gender': _gender,
        'Dob': _dateController.text,
        'Location': _city,
        'isComplete': true,
        'resumeUrl': resumeUrl,
        'resumeFileName': _selectedFileName ?? "",
      });
    } catch (e) {
      print('Error setting document: $e');
    }
  }
}
