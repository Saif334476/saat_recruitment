import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Nav Items/Ad Posting/new_ad_posting.dart';
import 'Nav Items/Ad Posting/validation_page.dart';
import 'Nav Items/jp_profile_page.dart';
import 'Nav Items/Job Ads Listing/list_job_ads.dart';

class CompanyDashBoard extends StatefulWidget {
  const CompanyDashBoard({super.key});

  @override
  CompanyDashBoardState createState() => CompanyDashBoardState();
}

class CompanyDashBoardState extends State<CompanyDashBoard> {
  int _currentIndex = 0;
  late PageController _pageController;
  bool isActive=false;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  void navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInCubic,
    );
  }
  late Stream<DocumentSnapshot<Map<String, dynamic>>> userStatusStream;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    userStatusStream = FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();

    userStatusStream.listen((snapshot) {
      if (snapshot.exists) {
        final updatedIsActive = snapshot.data()?['isActive'] ?? false;
        if (isActive != updatedIsActive) {
          setState(() {
            isActive = updatedIsActive;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomePage(),
          isActive == true
              ? const CompanyNewAdPosting(
                  jobAdId: null,
                  jobAdData: null,
                )
              : const SplashScreen(),
          const CompanyProfilePage()
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: BottomNavigationBar(
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
            unselectedLabelStyle:
                TextStyle(color: Colors.white10.withOpacity(0.5)),
            selectedLabelStyle: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset("assets/sirf_logo.png",),
            ),
            const Text(
              'SAAT',
              style: TextStyle(
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    color: Colors.black54,
                    blurRadius: 2.0,
                  ),
                ],
                fontWeight: FontWeight.w700,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info_outline,
                  size: 40,
                ))
          ],
        ),
        const Divider(
          color: Colors.grey,
        ),
        const JobAdsListView()
      ]),
    ));
  }
}
