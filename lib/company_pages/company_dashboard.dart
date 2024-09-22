import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saat_recruitment/company_pages/company_new_ad_posting.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/company_pages/company_profile_page.dart';
import 'package:saat_recruitment/company_pages/list_job_ads.dart';
import 'package:saat_recruitment/job_seeker_pages/job_seeker_profile.dart';
import 'package:saat_recruitment/job_seeker_pages/js_profile_page.dart';
import '../Models/job_seeker_model.dart';

class CompanyDashBoard extends StatefulWidget {
  const CompanyDashBoard({super.key});

  @override
  CompanyDashBoardState createState() => CompanyDashBoardState();
}

class CompanyDashBoardState extends State<CompanyDashBoard> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    const CompanyNewAdPosting(),
    const CompanyProfilePage(),
  ];

  void navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        iconSize: 30,
        onTap: navigateTo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.ad_units_outlined), label: 'Post New Ad'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        selectedItemColor: Colors.blueAccent,
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
    return Center(
        child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            // color: Colors.white,
            child: ListView(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.lightBlueAccent,
                                    blurRadius: 7,
                                    blurStyle: BlurStyle.outer),
                              ],
                            ),
                            child: TextField(
                              onSubmitted: (value) {},
                              onChanged: (value) {},
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                labelText: "Search Job AD",
                                hintText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                      width: 20.0,
                                      color: Colors.lightBlueAccent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.lightBlueAccent,
                                        width: 2)),
                                // boxShadow:const [BoxShadow(color: Colors.lightBlueAccent)],
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search_outlined),
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //         const JobSeekerProfile()));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  'Your Job ADs',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              JobAdsListView()
                            ])
                      ]))
            ])));
  }
}
