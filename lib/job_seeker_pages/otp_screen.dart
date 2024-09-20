//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/otp_verification.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';

class OtpScreen extends StatefulWidget {
  final String user;

  const OtpScreen({super.key, required this.user});

  @override
  State<OtpScreen> createState() => _JobSeekerSignupPageState();
}

class _JobSeekerSignupPageState extends State<OtpScreen> {
  TextEditingController mobileNumber = TextEditingController();
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
              child: Column(children: <Widget>[
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
                  padding: EdgeInsets.only(
                    top: 10,
                    right: 8,
                    left: 8,
                  ),
                  child: Text(
                    'We need to register your phone before getting started!',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 2.5, color: const Color(0xff1C4374)),
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
                          controller: mobileNumber,
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
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: CupertinoButton(
                    color: const Color(0xff1C4374),
                      child: const Text(
                        "Send OTP",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      onPressed: () async {
                        final String phoneController =
                            countryController.text + mobileNumber.text;
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException ex) {},
                          codeSent: (String verificationId, int? recentToken) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpVerification(
                                          verificationId: verificationId,
                                          phone: phoneController,
                                          user: widget.user,
                                        )));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                          phoneNumber: countryController.text.toString() +
                              mobileNumber.text.toString(),
                        );
                      }),
                )
              ])),
        ));

    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
