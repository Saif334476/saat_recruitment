import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:saat_recruitment/job_seeker_pages/job_seeker_profile.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';

import '../company_pages/company_form_page.dart';

class OtpVerification extends StatefulWidget {
  final String verificationId;
  String phone;
  final String user;
  OtpVerification({
    super.key,
    required this.user,
    required this.verificationId,
    required this.phone,
  });

  @override
  State<OtpVerification> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpVerification> {
  TextEditingController otpVerification = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.phone);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
        primary: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 70),
                child: SizedBox(
                  height: 250,
                  width: 200,
                  child: Image(
                      image: AssetImage('assets/otp.png'),
                      color: Color(0xff1C4374),
                      fit: BoxFit.fill),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Enter OTP we sent to number you provided ${widget.phone}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Pinput(
                  controller: otpVerification,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  onChanged: (value) {
                    code = value;
                  },
                  showCursor: true,
                  onCompleted: (pin) => code = pin,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                        color: const Color(0xff1C4374),
                        child: const Text(
                          "Verify OTP",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        onPressed: () async {
                          String smsCode = otpVerification.text;
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: widget.verificationId.toString(),
                            smsCode: smsCode,
                          );
                          try {
                            print(widget.phone);
                            await FirebaseAuth.instance
                                .signInWithCredential(credential);
                            print('Sign in successful');

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => JobSeekerProfile(
                            //         credentials: 'phone',
                            //         phone: widget.phone ?? ''),
                            //   ),
                            // );
                          } catch (ex) {
                            print(ex);
                          }
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("Edit Phone Number ?",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
