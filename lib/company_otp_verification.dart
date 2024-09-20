import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:saat_recruitment/company_pages/company_form_page.dart';
import 'package:saat_recruitment/company_otp.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';

class CompanyOtpScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  const CompanyOtpScreen(
      {super.key, required this.verificationId, required this.phone});

  @override
  State<CompanyOtpScreen> createState() => _CompanyOtpScreenState();
}

class _CompanyOtpScreenState extends State<CompanyOtpScreen> {
  TextEditingController otpVerification = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
        centerTitle: true,
        primary: true,
      ),
      body: ListView(children: [
        Container(
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
                child: Text(
                  'Enter OTP we sent to number you provided ${widget.phone}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  onChanged: (value) {},
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              //   child: textFieldWidget(
              //       text: "",
              //       icon: Icons.password,
              //       isPasswordType: false,
              //       controller: otpVerification,
              //       textInputType: TextInputType.number),
              // ),

              // Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              //     child: cupertinoButtonWidget("Verify OTP", () async {
              //       try {
              //         PhoneAuthCredential credential =
              //
              //         await PhoneAuthProvider.credential(
              //                 verificationId: widget.verificationId,
              //                 smsCode: otpVerification.text.toString());
              //         FirebaseAuth.instance
              //             .signInWithCredential(credential)
              //             .then((value) {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => const CompanyFormPage()));
              //         });
              //       } catch (ex) {
              //         log(ex.toString());
              //       }
              //     })),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 20),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        if (otpVerification.text.length != 6 ||
                            !otpVerification.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid SMS code')),
                          );
                          PhoneAuthCredential credential =
                              await PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpVerification.text.toString(),
                          );
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          Navigator.pop(context); // Hide loading indicator
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const CompanyFormPage()),
                         // );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Verification ID or SMS code is empty')),
                          );
                        }
                      } catch (ex) {
                        Navigator.pop(context); // Hide loading indicator
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${ex.toString()}')),
                        );
                      }
                    },
                    child: Text("Verify OTP"),
                  )
                  // cupertinoButtonWidget("Verify OTP", () async {
                  //   try {
                  //       if (otpVerification.text.length != 6 || !otpVerification.text.isNotEmpty) {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           const SnackBar(content: Text('Invalid SMS code')),
                  //         );
                  //       PhoneAuthCredential credential = await PhoneAuthProvider.credential(
                  //         verificationId: widget.verificationId,
                  //         smsCode: otpVerification.text.toString(),
                  //       );
                  //       await FirebaseAuth.instance.signInWithCredential(credential);
                  //       Navigator.pop(context); // Hide loading indicator
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => const CompanyFormPage()),
                  //       );
                  //     } else {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(content: Text('Verification ID or SMS code is empty')),
                  //       );
                  //     }
                  //   } catch (ex) {
                  //     Navigator.pop(context); // Hide loading indicator
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('Error: ${ex.toString()}')),
                  //     );
                  //   }
                  // }),
                  )
            ],
          ),
        ),
      ]),
    );
  }
}
