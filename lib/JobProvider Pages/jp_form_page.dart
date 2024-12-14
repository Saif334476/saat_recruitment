import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:saat_recruitment/reusable_widgets/profile_pic.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'jp_upload_documents.dart';

class CompanyFormPage extends StatefulWidget {
  final String? email;
  final String? credentials;
  final String? emailController;
  final String? uid;
  const CompanyFormPage(
      this.email, this.credentials, this.emailController, this.uid,
      {super.key});

  @override
  State<CompanyFormPage> createState() => _CompanyFormPageState();
}

class _CompanyFormPageState extends State<CompanyFormPage> {
  final TextEditingController _companyName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _location = TextEditingController();
  String? _selectedIndustry;
  final _formKey = GlobalKey<FormState>();
  String? _selectedCompanySize;
  final credential = FirebaseAuth.instance;
  File? profilePicFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text(
        //     "Job Provider Account Creation",
        //     style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        //   ),
        //   backgroundColor: const Color(0xff1C4374),
        // ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 50,),
                ProfilePicWidget(
                  onImagePicked: (imageUrl) {
                    setState(() {
                      profilePicFile=imageUrl;
                    });
                  },uploadedProfileUrl: "",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: textFormField(
                      onChanged: () {
                        setState(() {});
                      },
                      "Enter organization name",
                      Icons.business_sharp,
                      false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Company Name";
                        }
                        return null;
                      },
                      controller: _companyName,
                      keyboard: TextInputType.text),
                ),
                widget.credentials != "email"
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: textFormField(
                            onChanged: () {
                              setState(() {});
                            },
                            keyboard: TextInputType.text,
                            "E-mail",
                            Icons.email_outlined,
                            false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your E-mail";
                              }
                              return null;
                            },
                            controller: _email),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.red),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xff1C4374)),
                                  borderRadius: BorderRadius.circular(15)),
                              labelText: "Your Email",
                              prefixIcon: const Icon(Icons.email_outlined)),
                          initialValue: widget.emailController,
                          readOnly: true,
                        ),
                      ),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: dropDown(
                      value: _selectedIndustry,
                      text: "Industry",
                      icon: Icons.category_outlined,
                      items: [
                        'IT & Technology',
                        'Healthcare',
                        'Sales & Marketing',
                        'Finance & Accounting',
                        'Customer Service',
                        'Administration & HR',
                        'Engineering & Manufacturing',
                        'Creative & Design',
                        'Hospitality & Tourism',
                        'Education & Training',"Other"
                      ].map((industry) {
                        return DropdownMenuItem(
                          value: industry,
                          child: Text(industry),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an industry';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                      onChanged: (value) {
                        setState(() {
                          _selectedIndustry = value;
                        });
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: dropDown(
                      value: _selectedCompanySize,
                      text: "Company Size",
                      icon: Icons.business_sharp,
                      items: [
                        '1-10',
                        '11-50',
                        '51-100',
                        '101-500',
                        'More than 500'
                      ].map((companySize) {
                        return DropdownMenuItem(
                          value: companySize,
                          child: Text(companySize),
                        );
                      }).toList(),
                      onSaved: (value) {},
                      validator: (value) {
                        if (_selectedCompanySize == null ||
                            _selectedCompanySize == "Company Size") {
                          return 'Please select a company size';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedCompanySize = value;
                        });
                      },
                    )),
                const SizedBox(
                  height: 15,
                ),
                placesAutoCompleteTextField(_location),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Note: Please ensure all information is accurate and authentic, as it will be verified by our admin team. Incomplete or inaccurate data may delay or prevent account activation.",
                    style: TextStyle(shadows: [
                      BoxShadow(
                        blurStyle: BlurStyle.outer,
                      )
                    ], fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 30),
                  child: cupertinoButtonWidget("Next", () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JpUploadDocument(
                              name: _companyName.text,
                              location: _location.text,
                              industry: _selectedIndustry,
                              email: widget.emailController!.toString(),
                              companySize: _selectedCompanySize),
                        ),
                      );
                    }
                  }),
                )
              ]),
            ),
          ),
        ));
  }
}
