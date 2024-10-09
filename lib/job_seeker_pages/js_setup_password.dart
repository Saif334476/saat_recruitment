import 'dart:math';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/job_seeker_dashboard.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../Models/job_seeker_model.dart';


class JsSetupPassword extends StatefulWidget {
  const JsSetupPassword({super.key});
  @override
  State<JsSetupPassword> createState() => JsSetupPasswordState();
}

class JsSetupPasswordState extends State<JsSetupPassword> {
  bool obscuredTextOne = true;
  bool obscuredTextTwo = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String generateRandomSalt() {
    var randomBytes = Random.secure().nextInt(256);
    return base64Encode(randomBytes.toString().codeUnits);
  }

  String hashPassword(String password, String salt) {
    var bytes = utf8.encode(password + salt);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

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
                        child: SizedBox(height:200,width:200,child: Image.asset("assets/lock.webp")),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
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
                        padding: EdgeInsets.only(top: 20.0, right: 20, left: 20),
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
                          padding:
                              const EdgeInsets.only(top: 40, right: 15, left: 15),
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
                              else {
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
                            setState(() {});},
                          keyboard: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirm Password';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 65, left: 65),
                          child: cupertinoButtonWidget("Create Account", () {
                            // Basic password validation
                            if (_passwordController.text.isEmpty ||
                                _confirmPasswordController.text.isEmpty) {
                              // Show an error message (e.g., using a SnackBar)
                              return;
                            }
                
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              // Show an error message: Passwords don't match
                              return;
                            }
                
                            // Generate salt and hash password
                            String salt = generateRandomSalt();
                            String hashedPassword =
                                hashPassword(_passwordController.text, salt);
                
                            {
                              if (_formKey.currentState!.validate()) {
                                // Generate salt and hash password
                                String salt = generateRandomSalt();
                                String hashedPassword =
                                    hashPassword(_passwordController.text, salt);
                
                                // TODO: Store hashedPassword and salt securely (e.g., in a database)
                
                                // Navigate to the next screen or show a success message
                                _showSnackBar('Password set successfully!');
                
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NHomePage(), // Replace with your dashboard screen
                                  ),
                                );
                              }
                            }
                          }))
                    ]),
              ),
            )));
  }
}
