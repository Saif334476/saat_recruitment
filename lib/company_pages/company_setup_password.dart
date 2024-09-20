import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/company_pages/company_form_page.dart';
import 'package:saat_recruitment/login_page.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';

class CompanySetupPassword extends StatefulWidget {
  final TextEditingController email = TextEditingController();
  final String credentials;
  final TextEditingController emailController;
  CompanySetupPassword(email,
      {super.key, required this.credentials, required this.emailController});
  @override
  State<CompanySetupPassword> createState() => CompanySetupPasswordState();
}

class CompanySetupPasswordState extends State<CompanySetupPassword> {
  final bool profileCompleted = false;
  bool obscuredTextOne = true;
  bool obscuredTextTwo = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _credential = FirebaseAuth.instance;
  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/lock.webp")),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(top: 20.0, left: 20, right: 20),
                        child: Text(
                          "Create a Strong Password",
                          style: TextStyle(
                            shadows: [
                              BoxShadow(
                                  blurStyle: BlurStyle.outer,
                                  blurRadius: 2,
                                  offset: Offset(0, 1.25))
                            ],
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            color: Color(0xff1C4374),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(top: 20.0, right: 20, left: 20),
                        child: Text(
                          'It must contain one Uppercase letter, combination of numbers, letters and symbols (/@#%^&*+= etc)',
                          style: TextStyle(
                            shadows: [
                              BoxShadow(
                                  blurStyle: BlurStyle.outer,
                                  blurRadius: 2,
                                  offset: Offset(0, 0.5))
                            ],
                            fontSize: 17.5,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 40, right: 15, left: 15),
                          child: textFormField(
                            "Create a Strong Password",
                            Icons.lock_outline,
                            onChanged: () {
                              setState(() {});
                            },
                            controller: _passwordController,
                            suffixIcon: IconButton(
                              icon: Icon(obscuredTextOne
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  obscuredTextOne = !obscuredTextOne;
                                });
                              },
                            ),
                            obscuredTextOne,
                            keyboard: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Create Password';
                              }
                              String pattern =
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(value)) {
                                return 'Password must contain one special character and alphanumerics';
                              } else {
                                return null;
                              }
                            },
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 15, left: 15),
                        child: textFormField(
                          "Confirm Password",
                          Icons.lock_outline,
                          controller: _confirmPasswordController,
                          suffixIcon: IconButton(
                            icon: Icon(obscuredTextTwo
                                ? Icons.visibility_off_outlined
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscuredTextTwo = !obscuredTextTwo;
                              });
                            },
                          ),
                          obscuredTextTwo,
                          onChanged: () {
                            setState(() {});
                          },
                          keyboard: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirm Password';
                            } else if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 65, left: 65),
                          child: _isLoading
                              ? const CupertinoActivityIndicator()
                              : cupertinoButtonWidget("Create Account",
                                  () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    try {
                                      final credential = await FirebaseAuth
                                          .instance
                                          .createUserWithEmailAndPassword(
                                        email: widget.emailController.text,
                                        password:
                                            _confirmPasswordController.text,
                                      );

                                      await FirebaseFirestore.instance
                                          .collection('JobProviders')
                                          .doc(credential.user?.uid)
                                          .set({
                                        'role': widget.credentials,
                                        'isComplete': profileCompleted,
                                        'Email': widget.emailController.text
                                      });

                                      await credential.user!.updatePhotoURL(
                                          "assets/office1.webp");

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Success'),
                                            content: const Text(
                                                'Account successfully created!'),
                                            actions: [
                                              TextButton(
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const LoginPage()));
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => CompanyFormPage(
                                      //       widget.email,
                                      //       "email",
                                      //       widget.emailController,
                                      //       _credential.currentUser!.uid
                                      //           .toString(),
                                      //     ),
                                      //   ),
                                      // );
                                    } on FirebaseAuthException catch (e) {
                                      print('FirebaseAuthException: $e');
                                      if (e.code == 'weak-password') {
                                        print(
                                            'The password provided is too weak.');
                                      } else if (e.code ==
                                          'email-already-in-use') {
                                        print(
                                            'The account already exists for that email.');
                                      }
                                    } on FirebaseException catch (e) {
                                      print('FirebaseException: $e');
                                    } catch (e) {
                                      print('Error: $e');
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                }))
                    ]),
              ),
            )));
  }
}
