// import 'dart:core';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
// import 'package:intl/intl.dart';
// import '../Models/job_seeker_model.dart';
// import 'js_setup_password.dart';
// //import 'package:cloud_firestore/cloud_firestore.dart';
//
// class JobSeekerProfile extends StatefulWidget {
// final  String? email;
// final  String? credentials;
// final  String? emailController;
// final  String? uId;
//    const JobSeekerProfile(this.email, this.credentials, this.emailController, this.uId, {super.key});
//   @override
//   JobSeekerProfileState createState() => JobSeekerProfileState();
// }
//
// class JobSeekerProfileState extends State<JobSeekerProfile> {
//   final _formKey = GlobalKey<FormState>();
//   int _currentStep = 0;
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _name = TextEditingController();
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _phoneNumber = TextEditingController();
//   String _city = "";
//   String _gender = "";
//   String _education = "";
//   final TextEditingController _companyName = TextEditingController();
//   String _experienceDuration = "";
//   String _salary = "";
//   String _selectedOption = '';
//   String? _selectedFileName;
//   bool _isFileSelected = false;
//
//   @override
//   Widget build(BuildContext context) {
//    // print(widget.emailController?);
//     //print(widget.phone);
//     return Scaffold(
//         body: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               gradient: LinearGradient(
//                 colors: [Colors.white, Colors.blue],
//                 begin: Alignment(0.78, 0),
//                 end: Alignment(0.78, 0.77),
//               ),
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                   //  alignment: Alignment.topCenter,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(top: 70.0, right: 25, left: 25),
//                       child: Text("SIGN UP FORM",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(shadows: [
//                             BoxShadow(
//                                 blurStyle: BlurStyle.outer,
//                                 blurRadius: 3,
//                                 offset: Offset(0, 1.59))
//                           ], fontWeight: FontWeight.w900, fontSize: 35)),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                         child: Form(
//                           child: Stepper(
//                             key: _formKey,
//                             //type: StepperType.horizontal,
//                             currentStep: _currentStep,
//                             onStepTapped: (step) {
//                               setState(() {
//                                 _currentStep = step;
//                               });
//                             },
//                             onStepContinue: () {
//                               if (_currentStep < 2) {
//                                 setState(() {
//                                   _currentStep++;
//                                 });
//                               } else {
//                                 _saveJobSeekerData();
//                               }
//                             },
//                             onStepCancel: () {
//                               if (_currentStep > 0 && _currentStep <= 3) {
//                                 setState(() {
//                                   _currentStep--;
//                                 });
//                               }
//                             },
//                             steps: [
//                               Step(
//                                 isActive: _currentStep >= 0,
//                                 title: const Text(
//                                   'Personal Info.',
//                                   style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                                 content: Form(
//                                   child: Column(children: [
//                                     Padding(
//                                         padding: const EdgeInsets.only(top: 10),
//                                         child: textFormField(
//                                             keyboard: TextInputType.text,
//                                             onChanged: () {
//                                               setState(() {});
//                                             },
//                                             "Enter Your Name",
//                                             Icons.person,
//                                             false,
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return 'Please Enter Your Name';
//                                               } else {
//                                                 return null.toString();
//                                               }
//                                             },
//                                             controller: _name)),
//
//                                     Padding(
//                                         padding:
//                                         const EdgeInsets.only(top: 10),
//                                         child: textFormField(
//                                             keyboard: TextInputType.number,
//                                             onChanged: () {
//                                               setState(() {});
//                                             },
//                                             "Enter Phone Number",
//                                             Icons.phone_android_outlined,
//                                             false,
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return 'Enter Your Phone Number';
//                                               }
//                                               return null.toString();
//                                             },
//                                             controller: _phoneNumber)),
//
//                                     // widget.credentials != "phone"
//                                     //     ? Padding(
//                                     //         padding:
//                                     //             const EdgeInsets.only(top: 10),
//                                     //         child: textFormField(
//                                     //             keyboard: TextInputType.number,
//                                     //             onChanged: () {
//                                     //               setState(() {});
//                                     //             },
//                                     //             "Enter Phone Number",
//                                     //             Icons.phone_android_outlined,
//                                     //             false,
//                                     //             validator: (value) {
//                                     //               if (value!.isEmpty) {
//                                     //                 return 'Enter Your Phone Number';
//                                     //               }
//                                     //               return null.toString();
//                                     //             },
//                                     //             controller: _phoneNumber))
//                                     //     : Padding(
//                                     //         padding: const EdgeInsets.only(
//                                     //             top: 10.0),
//                                     //         child: TextFormField(
//                                     //           decoration: InputDecoration(
//                                     //               errorBorder:
//                                     //                   OutlineInputBorder(
//                                     //                       borderSide:
//                                     //                           const BorderSide(
//                                     //                               color:
//                                     //                                   Colors
//                                     //                                       .red),
//                                     //                       borderRadius:
//                                     //                           BorderRadius
//                                     //                               .circular(
//                                     //                                   15)),
//                                     //               border: OutlineInputBorder(
//                                     //                   borderSide:
//                                     //                       const BorderSide(
//                                     //                           color: Color(
//                                     //                               0xff1C4374)),
//                                     //                   borderRadius:
//                                     //                       BorderRadius.circular(
//                                     //                           15)),
//                                     //               labelText: "Your Phone",
//                                     //               prefixIcon: const Icon(
//                                     //                   Icons.email_outlined)),
//                                     //           initialValue: widget.phone,
//                                     //           readOnly: true,
//                                     //         ),
//                                     //       ),
//                                     widget.credentials != "email"
//                                         ? Padding(
//                                             padding:
//                                                 const EdgeInsets.only(top: 10),
//                                             child: textFormField(
//                                                 keyboard: TextInputType.text,
//                                                 onChanged: () {
//                                                   setState(() {});
//                                                 },
//                                                 "Enter Your E-mail",
//                                                 Icons.email,
//                                                 false,
//                                                 validator: (value) {
//                                                   if (value!.isEmpty) {
//                                                     return 'Enter Your E-mail';
//                                                   }
//                                                   return null.toString();
//                                                 },
//                                                 controller: _email
//                                                 // ..text = widget.lEmail.text
//                                                 ))
//                                         : Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 10.0),
//                                             child: TextFormField(
//                                               decoration: InputDecoration(
//                                                   errorBorder:
//                                                       OutlineInputBorder(
//                                                           borderSide:
//                                                               const BorderSide(
//                                                                   color:
//                                                                       Colors
//                                                                           .red),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       15)),
//                                                   border: OutlineInputBorder(
//                                                       borderSide:
//                                                           const BorderSide(
//                                                               color: Color(
//                                                                   0xff1C4374)),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15)),
//                                                   labelText: "Your Email",
//                                                   prefixIcon: const Icon(
//                                                       Icons.email_outlined)),
//                                               initialValue:
//                                                   widget.emailController,
//                                               readOnly: true,
//                                             ),
//                                           ),
//                                     Padding(
//                                         padding: const EdgeInsets.only(top: 10),
//                                         child: dropDown(
//                                           icon: Icons.person_add,
//                                           validator: (value) {
//                                             if (value == null) {
//                                               return 'Select Your Gender';
//                                             }
//                                             return null;
//                                           },
//                                           text: 'Gender',
//                                           items: ['Male', 'Female', 'Other']
//                                               .map((gender) {
//                                             return DropdownMenuItem(
//                                               value: gender,
//                                               child: Text(gender),
//                                             );
//                                           }).toList(),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               _gender = value;
//                                             });
//                                           },
//                                           onSaved: (value) {
//                                             setState(() {
//                                               _gender = value;
//                                             });
//                                           },
//                                         )),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 10),
//                                       child: TextField(
//                                         readOnly: true,
//                                         controller: _dateController,
//                                         onTap: () {
//                                           showDatePicker(
//                                             context: context,
//                                             initialDate: DateTime.now(),
//                                             firstDate: DateTime(1900),
//                                             lastDate: DateTime.now(),
//                                           ).then((pickedDate) {
//                                             if (pickedDate != null) {
//                                               _dateController.text =
//                                                   DateFormat.yMd()
//                                                       .format(pickedDate);
//                                             }
//                                           });
//                                         },
//                                         decoration: InputDecoration(
//                                             border: OutlineInputBorder(
//                                                 borderSide: const BorderSide(
//                                                     color: Colors.black12),
//                                                 borderRadius:
//                                                     BorderRadius.circular(15)),
//                                             labelText: 'Date of Birth',
//                                             prefixIcon: const Icon(
//                                               Icons.calendar_today_outlined,
//                                             )),
//                                       ),
//                                     ),
//                                     Padding(
//                                         padding: const EdgeInsets.only(top: 10),
//                                         child: dropDown(
//                                           icon: Icons.location_on_outlined,
//                                           validator: (value) {
//                                             if (value == null) {
//                                               return 'Select Your City';
//                                             }
//                                             return null;
//                                           },
//                                           onChanged: (value) {
//                                             setState(() {
//                                               _city = value;
//                                             });
//                                           },
//                                           onSaved: (value) {
//                                             _city = value;
//                                           },
//                                           text: 'Location',
//                                           items: [
//                                             'Karachi',
//                                             'Lahore',
//                                             'Faisalabad',
//                                             'Rawalpindi',
//                                             'Multan',
//                                             'Gujranwala',
//                                             'Hyderabad',
//                                             'Peshawar',
//                                             'Islamabad',
//                                             'Quetta',
//                                             'Sargodha',
//                                             'Sialkot',
//                                             'Bahawalpur',
//                                             'Sukkur',
//                                             'Gujrat',
//                                             'Sahiwal',
//                                             'Okara',
//                                             'Jhang',
//                                             'D.G Khan',
//                                             'Chiniot',
//                                             'Jehlum',
//                                             'Khanewal',
//                                             'Kohat',
//                                             'Bawalnagar',
//                                             'Chakwal',
//                                             'Mianwali'
//                                           ].map((city) {
//                                             return DropdownMenuItem(
//                                               value: city,
//                                               child: Text(city),
//                                             );
//                                           }).toList(),
//                                         )),
//                                   ]),
//                                 ),
//                               ),
//                               Step(
//                                   isActive: _currentStep >= 1,
//                                   title: const Text('Education & Career',
//                                       style: TextStyle(
//                                           fontSize: 22,
//                                           fontWeight: FontWeight.w700)),
//                                   content: Column(
//                                     children: [
//                                       Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 10),
//                                           child: dropDown(
//                                             icon: Icons.person_add,
//                                             validator: (value) {
//                                               if (value == null) {
//                                                 return 'Select Your Education';
//                                               } else {
//                                                 _currentStep++;
//                                               }
//                                               return null;
//                                             },
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 _education = value;
//                                               });
//                                             },
//                                             onSaved: (value) {
//                                               _education = value;
//                                             },
//                                             text: 'Education',
//                                             items: [
//                                               'Under-Matric',
//                                               'Matriculation',
//                                               'F.A/Fsc/ICs',
//                                               'Under-Graduate',
//                                               'Graduated',
//                                             ].map((education) {
//                                               return DropdownMenuItem(
//                                                 value: education,
//                                                 child: Text(education),
//                                               );
//                                             }).toList(),
//                                           )),
//                                       const Text(
//                                         'Do You have any work experience?',
//                                         style: TextStyle(fontSize: 18),
//                                       ),
//                                       RadioListTile(
//                                         value: 'Yes',
//                                         title: const Text('Yes'),
//                                         groupValue: _selectedOption,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             _selectedOption = value!;
//                                           });
//                                         },
//                                       ),
//                                       RadioListTile(
//                                         value: 'No',
//                                         title: const Text('No'),
//                                         groupValue: _selectedOption,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             _selectedOption = value!;
//                                           });
//                                         },
//                                       ),
//                                       _selectedOption == 'Yes'
//                                           ? Column(children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 10),
//                                                 child: TextFormField(
//                                                   controller: _companyName,
//                                                   decoration: InputDecoration(
//                                                       border: OutlineInputBorder(
//                                                           borderSide:
//                                                               const BorderSide(
//                                                                   color: Colors
//                                                                       .black12),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       15)),
//                                                       labelText:
//                                                           'Enter Company Name',
//                                                       prefixIcon: const Icon(
//                                                           Icons
//                                                               .cabin_outlined)),
//                                                   validator: (value) {
//                                                     if (value!.isEmpty) {
//                                                       return 'Please Company Name';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                               Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 10),
//                                                   child: dropDown(
//                                                     onSaved: (value) {
//                                                       _salary = value;
//                                                     },
//                                                     onChanged: (value) {
//                                                       setState(() {
//                                                         _salary = value;
//                                                       });
//                                                     },
//                                                     text: 'Salary',
//                                                     icon: Icons
//                                                         .price_check_outlined,
//                                                     items: [
//                                                       '10000-50000',
//                                                       '50000-100000',
//                                                       '100000-150000',
//                                                       '150000-200000',
//                                                       '200000-500000',
//                                                     ].map((salary) {
//                                                       return DropdownMenuItem(
//                                                         value: salary,
//                                                         child: Text(salary),
//                                                       );
//                                                     }).toList(),
//                                                     validator: (value) {
//                                                       if (value == null) {
//                                                         return 'Select Your Salary';
//                                                       } else {
//                                                         _currentStep++;
//                                                       }
//                                                       return null;
//                                                     },
//                                                   )),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 10),
//                                                 child: dropDown(
//                                                     text: 'Experience',
//                                                     icon:
//                                                         Icons.event_busy_sharp,
//                                                     items: [
//                                                       '1 Year',
//                                                       '2 Years',
//                                                       '3 Years',
//                                                       '4 Years',
//                                                       '5 years',
//                                                       'More than 5 Years'
//                                                     ].map((experience) {
//                                                       return DropdownMenuItem(
//                                                         value: experience,
//                                                         child: Text(experience),
//                                                       );
//                                                     }).toList(),
//                                                     onSaved: (value) {
//                                                       _experienceDuration =
//                                                           value;
//                                                     },
//                                                     onChanged: (value) {
//                                                       setState(() {
//                                                         _experienceDuration =
//                                                             value;
//                                                       });
//                                                     },
//                                                     validator: (value) {
//                                                       if (value == null) {
//                                                         return 'Select Experience';
//                                                       } else {
//                                                         _currentStep++;
//                                                       }
//                                                       return null;
//                                                     }),
//                                               ),
//                                             ])
//                                           : Container()
//                                     ],
//                                   )),
//                               Step(
//                                 isActive: _currentStep >= 2,
//                                 title: const Text('CV/Resume',
//                                     style: TextStyle(
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.w700)),
//                                 content: Column(
//                                   children: [
//                                     const Padding(
//                                       padding:
//                                           EdgeInsets.only(right: 10.0, top: 10),
//                                       child: Text(
//                                         "File's size must be 2MB or smaller",
//                                         style: TextStyle(
//                                             shadows: [
//                                               BoxShadow(
//                                                   blurStyle: BlurStyle.outer,
//                                                   blurRadius: 2,
//                                                   offset: Offset(0, .5))
//                                             ],
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xff1C4374)),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                     OutlinedButton(
//                                         onPressed: () async {
//                                           FilePickerResult? result =
//                                               await FilePicker.platform
//                                                   .pickFiles(
//                                             type: FileType.custom,
//                                             allowedExtensions: [
//                                               'pdf',
//                                               'doc',
//                                               'docx'
//                                             ],
//                                           );
//                                           if (result != null) {
//                                             PlatformFile file =
//                                                 result.files.first;
//                                             await Future.delayed(const Duration(
//                                                 seconds:
//                                                     0)); // Simulate upload time
//                                             setState(() {
//                                               _selectedFileName = file.name;
//                                               _isFileSelected = true;
//                                             });
//                                           }
//
//                                           // showCupertinoModalPopup(
//                                           //   context: context,
//                                           //   builder: (BuildContext context) {
//                                           //     return Scaffold(
//                                           //     body:
//                                           //         Container(
//                                           //       height: 200,
//                                           //       color: Colors.black,
//                                           //       child: const Column(
//                                           //         children: [
//                                           //
//                                           //           // Add your BottomSheet content here
//                                           //         ],
//                                           //       ),
//                                           //         ) );
//                                           //   },
//                                           // );
//                                           // Navigator.push(
//                                           //     context,
//                                           //     MaterialPageRoute(
//                                           //       builder: (context) =>
//                                           //           JsSetupPassword(
//
//                                           //                           ),
//                                           //     )
//                                           //     );
//                                         },
//                                         child: const Text(
//                                           'Upload CV/Resume',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 20),
//                                         )),
//                                     if (_isFileSelected)
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           const Icon(Icons.file_present),
//                                           const SizedBox(width: 8),
//                                           SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 2,
//                                             child: Expanded(
//                                               child: Text(
//                                                 _selectedFileName!,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 maxLines: 1, // Limit to 3 lines
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.black,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ]),
//             )));
//   }
//
//   void _saveJobSeekerData() async {
//     JobSeeker jobSeeker = JobSeeker(
//       jsName: _name.text,
//       jsEmail: _email.text,
//       jsGender: _gender,
//       jsDob: _dateController.text,
//       jsCity: _city,
//       jsEducation: _education,
//       jsExperience: _selectedOption,
//       jsCompanyName: _selectedOption == 'Yes' ? _companyName.text : '',
//       jsExperienceDuration: _experienceDuration,
//       jsSalary: _salary,
//       cvFileName: _selectedFileName ?? '', // Handle null value
//     );
//
//     try {
//       //  final CollectionReference<Map<String, dynamic>> jobSeekersCollection =
//       //    FirebaseFirestore.instance.collection(
//       //       'jobSeekers');
//       //  await jobSeekersCollection.add(jobSeeker.toMap());
//
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Job seeker data saved!')));
//     } catch (error) {
//       print('Error saving job seeker data: $error');
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Error saving data')));
//     }
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => const JsSetupPassword()));
//   }
// }
