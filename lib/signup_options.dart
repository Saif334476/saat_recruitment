import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/sign_in_e_mail.dart';

import 'job_seeker_pages/otp_screen.dart';

class SignupOptions extends StatefulWidget {
  const SignupOptions({super.key,required String user});

  @override
  State<SignupOptions> createState() => _SignupOptionsState();
}

class _SignupOptionsState extends State<SignupOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.88, 0),
            end: Alignment(0.78, 0.77),
            colors: <Color>[
              Colors.white,
              Colors.blue,
              // Color(0xFFBCE3C5),
              // Color(0xFFC7B8EA),
            ],
            tileMode: TileMode.mirror,
          ),
                ),
                child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200, right: 25, left: 25),
              child: Text(
                "Tab to continue with your choice!",
                style: TextStyle(
                  fontWeight:FontWeight.w900,
                  fontSize: 30,
                  color: Color(0xff1C4374),
                  shadows: [
                    Shadow(
                        blurRadius: 2,
                        color: Colors.black,
                        offset: Offset(0, 1.65))
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 75,
                right: 14,
                left: 14,
              ),
              child: CupertinoButton(
                  color: const Color(0xff1C4374),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OtpScreen(
                                  user: 'JobSeeker',
                                )));
                  },
                  child:  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height:50,width:50,child: Image.asset("assets/phone.webp")),
                        // Icon(
                        //   Icons.phone_android_outlined,
                        //   size: 50,
                        //   color: Colors.blue,
                        // ),
                        const Text(
                          "      Register With Phone",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )),
            ),
            // const Padding(
            //   padding: EdgeInsets.all(15.0),
            //   child: Divider(
            //     height: 10,
            //     thickness: 2,
            //     color: Color(0xff1C4374),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 14, left: 14),
              child: CupertinoButton(
                  color: const Color(0xff1C4374),
                  child:  Row(
                    children: [
                      SizedBox(height:50,width:50,child: Image.asset("assets/mail1.webp")),
                      // Icon(
                      //   Icons.email_outlined,
                      //   size: 50,
                      //   color: Colors.blue,
                      // ),
                      const Text("      Register With E-mail",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInEMail(user: 'jobseeker',)));
                  }),
            ),
          ],
                ),
              ),
        ));
  }
}
