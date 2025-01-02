import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'email_otp_verification.dart';

class SignInEMail extends StatefulWidget {
  final String user;
  const SignInEMail({super.key, required this.user});

  @override
  State<SignInEMail> createState() => _SignInEMailState();
}

class _SignInEMailState extends State<SignInEMail> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Form submitted successfully');
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 75.0),
          child: SizedBox(
              height: 220,
              width: 220,
              child: Image.asset(
                "assets/mail002.webp",
                color: const Color(0xff1C4374),
              )),
        ),
        Column(
          children: [
            Form(
              key: _formKey,
                child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 45.0, right: 20, left: 20),
                  child: Text(
                    "We will send OTP to verify your E-mail",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 20, left: 20),
                  child: textFormField(
                      keyboard: TextInputType.text,
                      "Enter Your E-mail",
                      Icons.email_outlined,
                      false,
                      controller: emailController,
                      validator: emailValidator),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CupertinoButton(
                  color: const Color(0xff1C4374),
                  onPressed: () async {
                    _submit();
                    // sendOtp();
                    // verifyOtp();
                    EmailOTP.config(
                      appEmail: emailController.text,
                      appName: "SAAT",
                      expiry: 10000000000,
                      otpLength: 6,
                      otpType: OTPType.numeric,
                    );
                    if (await EmailOTP.sendOTP(email: emailController.text) ==
                        true) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Otp Sent Successfully")));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                    user: widget.user,
                                    EmailOTP: EmailOTP,
                                    emailController: emailController,
                                  )));
                    } else {
                      print("Error sending verification mail");
                    }
                  },
                  child: const Text(
                    "Send OTP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
            ),
          ],
        )
      ]),
    ));
  }
}
