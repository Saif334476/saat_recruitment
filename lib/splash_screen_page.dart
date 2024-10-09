import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:gap/gap.dart";
import 'package:saat_recruitment/job_seeker_pages/job_seeker_form.dart';
import 'package:saat_recruitment/login_page.dart';

import 'company_pages/company_dashboard.dart';
import 'company_pages/company_form_page.dart';
//import 'job_seeker_pages/dashboard/bottom_navigation/bottom_navigation.dart';
import 'job_seeker_pages/dashboard/job_seeker_dashboard.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uId = user.uid;
        final doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(uId)
            .get();

        if (doc.exists) {
          final data = doc.data();
          final role = data?['role'];
          final profileStatus = data?['isComplete'];
          final userEmail = data?['Email'];

          if (role == 'JobSeeker' && profileStatus==true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NHomePage()),
            );
          }
          if (role == 'JobSeeker' && profileStatus == false) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  JobSeekerProfile(userEmail, "email", userEmail, uId)),
            );
          }
          else if (role == 'JobProvider' && profileStatus == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CompanyDashBoard()),
            );
          } else if (role == 'JobProvider' && profileStatus == false) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CompanyFormPage(userEmail, "email", userEmail, uId)),
            );
          } else if (role == 'Admin') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const NHomePage()),
              (route) => false,
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white
              // gradient: LinearGradient(
              //     colors: [Colors.white, Colors.blue],
              //     end: Alignment.topCenter,
              //     begin: Alignment.bottomCenter)
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 350,
                width: 350,
                child: Image.asset(
                  "assets/round_latest.png",
                )),
            const Gap(20),
            // const Text(
            //   "SAAT",
            //   style: TextStyle(
            //       fontSize: 50,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.blueGrey),
            //   textAlign: TextAlign.center,
            // )
          ],
        ),
      ),
    );
  }
}
