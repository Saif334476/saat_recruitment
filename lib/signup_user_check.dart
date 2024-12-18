import 'package:flutter/material.dart';
import 'package:saat_recruitment/sign_in_e_mail.dart';

class UserCheck extends StatelessWidget {
  const UserCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(right: 5.0,left: 5),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              const Padding(
                padding:
                    EdgeInsets.only(top: 200, bottom: 20, right: 20, left: 20),
                child: Text(
                  'Tap below to continue!',
                  style: TextStyle(
                      shadows: [
                        Shadow(
                            blurRadius: 1,
                            color: Colors.black,
                            offset: Offset(0, 1.5))
                      ],
                      fontSize: 33,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff1C4374)),
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
                              color: Color(0xff1C4374),
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
                                  height: MediaQuery.of(context).size.height*0.15,
                                  width: MediaQuery.of(context).size.width*0.25,
                                  child: Image.asset("assets/jobseeker2.webp"),
                                ),
                              ],
                            )),
                         SizedBox(
                          width: MediaQuery.of(context).size.width*0.50,
                          child: const Text(
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
                            ),overflow: TextOverflow.ellipsis
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
                              color: Color(0xff1C4374),
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
                                  height: MediaQuery.of(context).size.height*0.15,
                                  width: MediaQuery.of(context).size.width*0.25,
                                  child: Image.asset("assets/provider1.webp"),
                                )
                              ],
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.50,
                          child: const Text(
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
                                color: Color(0xff1C4374),overflow: TextOverflow.ellipsis),
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
                                  user: 'JobProvider',
                                )));
                  },
                ),
              ),

            ]),
          ),
        ));
  }
}
