import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:pinput/pinput.dart';
import 'package:saat_recruitment/company_pages/company_form_page.dart';
import 'package:saat_recruitment/company_pages/company_setup_password.dart';
import 'package:saat_recruitment/job_seeker_pages/job_seeker_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  final String user;
  final TextEditingController emailController;
  final EmailOTP;

  const OtpScreen(
      {super.key,
      required this.EmailOTP,
      required this.user,
      required this.emailController});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.emailController.text);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(
            // color: const Color.fromRGBO(234, 239, 243, 1
            color: const Color(0xff1C4374)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(44, 59, 73, 1.0)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code = "";

    return Scaffold(
      // appBar: AppBar(
      //  backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.arrow_back_ios_new),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(Icons.info),
      //     ),
      //   ],
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              colors: [Colors.white, Colors.blue],
              begin: Alignment(1, 0.54),
              end: Alignment(.2, 0.7)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              const Icon(
                Icons.dialpad_rounded,
                size: 70,
                color: Color(0xff1C4374),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Enter OTP ,We have just sent to "${widget.emailController.text}"',
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Pinput(
                    controller: otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    // onChanged: (value) {
                    //   code = value;
                    // },
                    showCursor: true,
                    onCompleted: (value) => code = value,

                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Didn't get email",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 40,
              ),
              CupertinoButton(
                color: const Color(0xff23408F),
                onPressed: () async {

                  if (await EmailOTP.verifyOTP(otp: otpController.text) == true) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("OTP is verified"),
                    ));
                    if (widget.user == "JobSeeker") {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanySetupPassword(
                                widget.emailController,
                                credentials: "JobSeeker",
                                emailController: widget.emailController,
                              )));

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => JobSeekerProfile(
                      //               emailController: widget.emailController,
                      //               credentials: 'email',
                      //             )));


                    } else if (widget.user == "JobProvider") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanySetupPassword(
                                    widget.emailController,
                                    credentials: "JobProvider",
                                    emailController: widget.emailController,
                                  )));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Invalid OTP"),
                    ));
                  }
                },
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
