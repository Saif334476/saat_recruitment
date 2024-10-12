import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'company_otp_verification.dart';

class CompanySignUpPage extends StatefulWidget {
  const CompanySignUpPage({super.key});

  @override
  State<CompanySignUpPage> createState() => _CompanySignUpPageState();
}

class _CompanySignUpPageState extends State<CompanySignUpPage> {
  final TextEditingController numberForOtp = TextEditingController();
  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+92";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: SizedBox(
                height: 250,
                width: 200,
                child: Image(
                    image: AssetImage('assets/otp.png'),
                    color: Color(0xff1C4374),
                    fit: BoxFit.fill),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 20,
                right: 3,
                left: 3,
              ),
              child: Text(
                'Phone Verification',
                style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'We need to register your phone before getting started!',
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 15, right: 15),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.5, color: const Color(0xff1C4374)),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(
                        fontSize: 33,
                        color: Color(0xff1C4374),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      controller: numberForOtp,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone Number",
                      ),
                    ))
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: cupertinoButtonWidget("Send OTP", () async {
            //     await FirebaseAuth.instance.verifyPhoneNumber(
            //         verificationCompleted:
            //             (PhoneAuthCredential credential) {},
            //         verificationFailed: (FirebaseAuthException ex) {},
            //         codeSent: (String verificationid, int? recentToken) {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => CompanyOtpScreen(
            //                         verificationid: verificationid,
            //                       )));
            //         },
            //         codeAutoRetrievalTimeout: (String verificationid) {},
            //         phoneNumber: _numberForotp.text.toString());
            //   }
            //       ),
            // ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 15, right: 15),
              child: elevatedButton("Send OTP", () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                    verificationCompleted:
                        (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException ex) {},
                    codeSent: (String verificationId, int? recentToken) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyOtpScreen(
                                    verificationId: verificationId,
                                    phone: countryController.text
                                            .toString() +
                                        numberForOtp.text.toString(),
                                  )));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                    phoneNumber: countryController.text.toString() +
                        numberForOtp.text.toString());
              }),
            )
          ]),
        ));
  }
}
