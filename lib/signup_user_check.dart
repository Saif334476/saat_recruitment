import 'package:flutter/material.dart';
import 'package:saat_recruitment/sign_in_e_mail.dart';
import 'package:saat_recruitment/signup_options.dart';

class UserCheck extends StatelessWidget {
  const UserCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(children: <Widget>[
              const Padding(
                padding:
                    EdgeInsets.only(top: 200, bottom: 20, right: 20, left: 20),
                child: Text(
                  'Select from below to continue!',
                  style: TextStyle(
                      shadows: [
                        Shadow(
                            blurRadius: 1,
                            color: Colors.black,
                            offset: Offset(0, 1.5))
                      ],
                      fontSize: 33,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 10, left: 10),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 7,
                              blurStyle: BlurStyle.outer)
                        ]),
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 15.0, left: 15),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: Image.asset("assets/jobseeker2.webp"),
                                ),
                              ],
                            )),
                        const Text(
                          "JOB SEEKER",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Color(0xff1C4374),
                            shadows: [
                              Shadow(
                                  blurRadius: 6,
                                  color: Colors.black,
                                  offset: Offset(0, 2.5))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInEMail(
                                  user: 'JobSeeker',
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 7,
                              blurStyle: BlurStyle.outer)
                        ]),
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                right: 15.0, left: 15),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: Image.asset("assets/provider1.webp"),
                                )
                              ],
                            )),
                        const Text(
                          "JOB PROVIDER",
                          style: TextStyle(
                              shadows: [
                                Shadow(
                                    blurRadius: 6,
                                    color: Colors.black,
                                    offset: Offset(0, 2.5))
                              ],
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Color(0xff1C4374)),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInEMail(
                                  user: 'JobProvider',
                                )));
                  },
                ),
              ),
            ])));
  }
}
