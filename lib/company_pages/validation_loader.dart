import 'dart:async';
import 'package:saat_recruitment/company_pages/company_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/company_pages/company_setup_password.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  double _progress = 0.0;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    controller.addListener(() {
      setState(() {
        _progress = controller.value;
      });
    });
    controller.repeat();
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CompanyDashBoard(),
          ));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: _progress,
                      semanticsValue: 'Loading...',
                      semanticsLabel: 'Load vim...',
                      color: Colors.blueGrey,
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.lightBlueAccent),
                          boxShadow: const [
                            BoxShadow(
                                blurStyle: BlurStyle.outer,
                                blurRadius: 7,
                                color: Colors.lightBlueAccent)
                          ]),
                      child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Note:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Data Validation in progress...We\'re working to ensure a secure experience for all users.Your account will be ready in 24 hours',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27,
                                  color: Colors.black38),
                              textAlign: TextAlign.center,
                            )
                          ])))
            ])));
  }
}
