import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/splash_screen_page.dart';
//import 'package:splash_screen_view/SplashScreenView.dart';
import 'firebase_options.dart';
//import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.appAttest,
  // );
  runApp(MyApp());
}

ThemeData myTheme = ThemeData(
  primaryColor: const Color(0xff1C4374).withOpacity(0.4),
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1C4374),
      onPrimary: Color(0xff5c8ec8),
      onSecondary: Color(0xff5f96d6),
      error: Color(0xff1C4374),
      onError: Color(0xff1C4374),
      surface: Colors.white,
      onSurface: Color(0xff1C4374),
      secondary: Color(0xff1C4374)),
);

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final userAccount = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      home: const SplashScreenPage(),
      // home: Container(
      //   decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //           colors: [Colors.white, Colors.blue],
      //           end: Alignment.bottomCenter,
      //           begin: Alignment.topCenter)),
      //   child: SplashScreenView(
      //     navigateRoute: ?userAccount. sHomePage(),
      //     duration: 3000,
      //     imageSize: 300,
      //     imageSrc:'assets/round_latest.png',
      //   ),
      // )
    );
  }
}
