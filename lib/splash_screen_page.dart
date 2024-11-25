import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:gap/gap.dart";
import 'package:saat_recruitment/job_seeker_pages/job_seeker_form.dart';
import 'package:saat_recruitment/login_page.dart';
import 'Admin_Panel/admin_panel.dart';
import 'JobProvider Pages/JP Nav Bar/jp_nav_bar.dart';
import 'JobProvider Pages/jp_form_page.dart';
import 'job_seeker_pages/dashboard/bottom_navigation/js_bottom_nav_bar.dart';

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
        final doc =
            await FirebaseFirestore.instance.collection('Users').doc(uId).get();

        if (doc.exists) {
          final data = doc.data();
          final role = data?['role'];
          final profileStatus = data?['isComplete'];
          final userEmail = data?['Email'];

          if (role == 'JobSeeker' && profileStatus == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const JsBottomNavigationBar()),
            );
          }
          if (role == 'JobSeeker' && profileStatus == false) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      JobSeekerProfile(userEmail, "email", userEmail, uId)),
            );
          } else if (role == 'JobProvider' && profileStatus == true) {
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminPanel()),
            );
          }
        }
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white

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
