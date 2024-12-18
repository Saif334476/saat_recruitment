import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/login_page.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';

class SetupPasswordScreen extends StatefulWidget {
  final TextEditingController email = TextEditingController();
  final String credentials;
  final TextEditingController emailController;
  SetupPasswordScreen(email,
      {super.key, required this.credentials, required this.emailController});
  @override
  State<SetupPasswordScreen> createState() => SetupPasswordScreenState();
}

class SetupPasswordScreenState extends State<SetupPasswordScreen> {
  final bool profileCompleted = false;
  bool obscuredTextOne = true;
  bool obscuredTextTwo = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _credential = FirebaseAuth.instance;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasDigits = false;
  bool _hasSpecialChar = false;
  bool _isLongEnough = false;
  void _checkPasswordStrength(String value) {
    setState(() {
      _hasUpperCase = RegExp(r'(?=.*[A-Z])').hasMatch(value);
      _hasLowerCase = RegExp(r'(?=.*[a-z])').hasMatch(value);
      _hasDigits = RegExp(r'(?=.*\d)').hasMatch(value);
      _hasSpecialChar = RegExp(r'(?=.*[@$#!%*?&])').hasMatch(value);
      _isLongEnough = value.length >= 8;
    });
  }

  Widget _buildConditionRow(bool isValid, String condition) {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Text(condition),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.asset(
                    "assets/lock.webp",
                    color: const Color(0xff1C4374),
                  )),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: Text(
                "Create a Strong Password",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Color(0xff1C4374),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildConditionRow(
                  _hasUpperCase,
                  'At least one uppercase letter',
                ),
                _buildConditionRow(
                  _hasLowerCase,
                  'At least one lowercase letter',
                ),
                _buildConditionRow(
                  _hasDigits,
                  'At least one digit',
                ),
                _buildConditionRow(
                  _hasSpecialChar,
                  'At least one special character',
                ),
                _buildConditionRow(
                  _isLongEnough,
                  'At least 8 characters long',
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                child: textFormField(
                  "Create a Strong Password",
                  Icons.lock_outline,
                  onChanged: (String value) {
                    _checkPasswordStrength(value);
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
                    // String pattern =
                    //     r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&]{8,}$';
                    // RegExp regex = RegExp(pattern);
                    else if (_hasDigits == false) {
                      return 'password must contain at least one digit';
                    } else if (_hasLowerCase == false ) {
                      return 'must contain at least one lower case';
                    } else if (_hasSpecialChar == false ) {
                      return 'must contain at least one special character';
                    } else if (_hasUpperCase == false) {
                      return 'must contain at least one upper case';
                    }
                    return null;
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
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
                padding: const EdgeInsets.only(top: 20.0, right: 65, left: 65),
                child: _isLoading
                    ? const CupertinoActivityIndicator()
                    : cupertinoButtonWidget("Create Account", () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: widget.emailController.text,
                              password: _confirmPasswordController.text,
                            );

                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(credential.user?.uid)
                                .set({
                              'role': widget.credentials,
                              'isComplete': profileCompleted,
                              'Email': widget.emailController.text,
                              'accountCreatedWith':"email"
                            });

                            await credential.user!
                                .updatePhotoURL("assets/office1.webp");

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
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } on FirebaseAuthException catch (e) {
                            print('FirebaseAuthException: $e');
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'The account already exists for that email.'),
                                    content:
                                        Text('An error occurred: ${e.message}'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            print('Error: $e');
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      })),
          ]),
        ),
      )),
    );
  }
}
