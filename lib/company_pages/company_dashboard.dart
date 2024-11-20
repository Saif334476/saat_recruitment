import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saat_recruitment/company_pages/company_new_ad_posting.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/company_pages/company_profile_page.dart';
import 'package:saat_recruitment/company_pages/list_job_ads.dart';
import 'package:saat_recruitment/company_pages/validation_loader.dart';

class CompanyDashBoard extends StatefulWidget {
  const CompanyDashBoard({super.key});

  @override
  CompanyDashBoardState createState() => CompanyDashBoardState();
}

class CompanyDashBoardState extends State<CompanyDashBoard> {
  int _currentIndex = 0;

  bool? isActive;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  void navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _checkUserStatus() async {
    final doc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      isActive = doc.get('isActive');
    });
  }

  @override
  void initState() {
    _checkUserStatus();
    super.initState();
  }
  // final List<Widget> _children = [
  //   HomePage(),
  //   const CompanyNewAdPosting(
  //     jobAdData: null,
  //     jobAdId: null,
  //   ),
  //   const CompanyProfilePage(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomePage(),
        isActive == true
            ? const CompanyNewAdPosting(
                jobAdId: null,
                jobAdData: null,
              )
            : const SplashScreen(),
        const CompanyProfilePage()
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        backgroundColor: const Color(0xff1C4374),
        currentIndex: _currentIndex,
        iconSize: 30,
        onTap: navigateTo,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.ad_units_outlined,
              ),
              label: 'Post New Ad'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile')
        ],
        selectedItemColor: const Color(0xff97C5FF),
        unselectedLabelStyle: TextStyle(color: Colors.white10.withOpacity(0.5)),
        selectedLabelStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1C4374),
          automaticallyImplyLeading: false,
          title: const Text(
            "Home",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(children: [
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8, right: 8),
                    //   child: TextField(
                    //     onSubmitted: (value) {},
                    //     onChanged: (value) {},
                    //     textInputAction: TextInputAction.search,
                    //     decoration: InputDecoration(
                    //       labelText: "Search Job AD",
                    //       hintText: "",
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(20.0),
                    //         borderSide: const BorderSide(
                    //             width: 20.0, color: Color(0xff1C4374)),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(20),
                    //           borderSide: const BorderSide(
                    //               color: Color(0xff1C4374), width: 2)),
                    //       // boxShadow:const [BoxShadow(color: Colors.lightBlueAccent)],
                    //       suffixIcon: IconButton(
                    //         icon: const Icon(Icons.search_outlined),
                    //         onPressed: () {
                    //           // Navigator.push(
                    //           //     context,
                    //           //     MaterialPageRoute(
                    //           //         builder: (context) =>
                    //           //         const JobSeekerProfile()));
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Posted Jobs',
                              style: TextStyle(
                                // decoration: TextDecoration.underline,
                                // decorationColor: Color(0xff1C4374), // Optional
                                // decorationStyle: TextDecorationStyle.dotted, // Optional
                                // decorationThickness: 2,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    color: Colors.black54,
                                    blurRadius: 2.0,
                                  ),
                                ],
                                fontWeight: FontWeight.w900,
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          JobAdsListView()
                        ])
                  ]))
        ]));
  }
}
