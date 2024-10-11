import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/admin_panel.dart';
import 'package:saat_recruitment/company_pages/company_dashboard.dart';
import 'package:saat_recruitment/company_pages/company_form_page.dart';
import 'package:saat_recruitment/job_seeker_pages/job_seeker_profile.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'package:flutter/cupertino.dart';
//import 'job_seeker_pages/dashboard/bottom_navigation/bottom_navigation.dart';
import 'job_seeker_pages/dashboard/job_seeker_dashboard.dart';
import 'job_seeker_pages/job_seeker_form.dart';
import 'signup_user_check.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscuredText = true;
  bool _isLoading = false;
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          // gradient: LinearGradient(
          //     colors: [Colors.white, Colors.blue],
          //     begin: Alignment(2.5, 0.33),
          //     end: Alignment(0.2, 1.75)),
        ),
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 100),
                child: logoWidget("assets/round_latest.png", 250, 250)),
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 25, left: 25),
              child: TextFormField(
                controller: _phoneTextController,
                obscureText: false,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff1C4374)),
                      borderRadius: BorderRadius.circular(15)),
                  labelText: "Enter E-mail or Phone",
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter E-mail or Password";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 25, left: 25),
              child: TextFormField(
                controller: _passwordTextController,
                obscureText: obscuredText,
                decoration: InputDecoration(
                  focusColor: const Color(0xff1C4374),
                  errorStyle: const TextStyle(color: Colors.red),
                  errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff1C4374)),
                      borderRadius: BorderRadius.circular(15)),
                  labelText: "Enter your Password",
                  prefixIcon:
                      const Icon(Icons.password_outlined, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscuredText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility,
                        color: Colors.black),
                    onPressed: () {
                      setState(() {
                        obscuredText = !obscuredText;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Your Password";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 28.0),
                    child: Text("Forgotten password,"),
                  ),
                  InkWell(
                      child: const Text(
                        "Reset Password?",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserCheck()));
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xff1C4374),
                            blurRadius: 5,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: CupertinoButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              final user = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: _phoneTextController.text,
                                password: _passwordTextController.text,
                              )
                                  .then((user) async {
                                final role = await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(user.user?.uid)
                                    .get()
                                    .then((doc) => doc.data()?['role']);
                                final uId =
                                    FirebaseAuth.instance.currentUser?.uid;

                                final profileStatus = await FirebaseFirestore
                                    .instance
                                    .collection('Users')
                                    .doc(user.user?.uid)
                                    .get()
                                    .then((doc) => doc.data()?['isComplete']);

                                if (role == 'JobSeeker' &&
                                    profileStatus == true) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NHomePage()),
                                  );
                                } else if (role == 'JobSeeker' &&
                                    profileStatus == false) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JobSeekerProfile(
                                            _phoneTextController.text,
                                            'email',
                                            _phoneTextController.text,
                                            uId)),
                                  );
                                } else if (role == 'JobProvider' &&
                                    profileStatus == true) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CompanyDashBoard()),
                                    (route) => false,
                                  );
                                } else if (role == 'JobProvider' &&
                                    profileStatus == false) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CompanyFormPage(
                                            _phoneTextController.text,
                                            "email",
                                            _phoneTextController.text,
                                            uId)),
                                  );
                                } else if (role == 'Admin') {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NHomePage()),
                                    (route) => false,
                                  );
                                }
                              });
                            } on FirebaseAuthException catch (e) {
                              Dialog(child: Text('Login failed: ${e.message}'));
                            }
                          }
                        },
                        color: const Color(0xff1C4374),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        pressedOpacity: 0.3,
                        child: _isLoading
                            ? const SizedBox(height:20,width:25,child: CircularProgressIndicator(color: Colors.white,))
                            : const Text(
                                'LOG IN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xff1C4374),
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer)
                    ]),
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserCheck()));
                  },
                  color: const Color(0xff1C4374),
                  borderRadius: BorderRadius.circular(15),
                  pressedOpacity: 0.3,
                  child: const Text(
                    'Create New Account',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xff1C4374),
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer)
                    ]),
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminPanel()));
                  },
                  color: const Color(0xff1C4374),
                  borderRadius: BorderRadius.circular(15),
                  pressedOpacity: 0.3,
                  child: const Text(
                    'Continue as a Guest',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    ));
  }
}
