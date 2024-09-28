// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saat_recruitment/company_pages/company_upload_documents.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';

class CompanyFormPage extends StatefulWidget {
  final String? email;
  final String? credentials;
  final String? emailController;
  final String? uid;
  const CompanyFormPage(this.email, this.credentials, this.emailController, this.uid, {super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                colors: [Colors.white, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset("assets/office1.webp"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: textFormField(
                      onChanged: () {
                        setState(() {});
                      },
                      "Company Name",
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
                        'Education & Training'
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
                // TypeAheadField(
                //   textFieldConfiguration: TextFieldConfiguration(
                //     controller: _location,
                //     decoration: const InputDecoration(
                //       labelText: 'Location',
                //       prefixIcon: Icon(Icons.location_on),
                //     ),
                //   ),
                //   suggestionsCallback: (pattern) async {
                //     const url = 'AIzaSyAFfgSfMIBv_o5qdlm8fSmt_zeqYfl_3mE';
                //     final response = await http.get(Uri.parse(url));
                //     final data = jsonDecode(response.body);
                //     return data.map((location) => location['display_name']).toList();
                //   },
                //   itemBuilder: (context, suggestion) {
                //     return ListTile(
                //       title: Text(suggestion.toString()),
                //     );
                //   },
                //   onSuggestionSelected: (suggestion) {
                //     _location.text = suggestion.toString();
                //   },
                // ),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: textFormField(
                        keyboard: TextInputType.text,
                        onChanged: () {
                          setState(() {});
                        },
                        "Location",
                        Icons.location_on_outlined,
                        false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the job location';
                          }
                          return null;
                        },
                        controller: _location)),
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
                      try {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.uid)
                            .update({
                          'Name': _companyName.text,
                          'Location': _location.text,
                          'CompanySize': _selectedCompanySize,
                          'Industry': _selectedIndustry,
                          'Email': widget.emailController,
                          'isComplete': true
                        });
                      } catch (e) {
                        print('Error setting document: $e');
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompanyVerificationPage(),
                        ),
                      );
                    }
                  }),
                )
              ]),
            ),
          )),
    ));

    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
