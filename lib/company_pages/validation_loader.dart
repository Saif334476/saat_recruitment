import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "User Validation",
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
          backgroundColor: const Color(0xff1C4374),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset("assets/buss1.webp")),
                const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Data Validation in progress...We\'re working to ensure a secure experience for all users.Your account will be ready in 24 hours',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                            color: Color(0xff1C4374)),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
