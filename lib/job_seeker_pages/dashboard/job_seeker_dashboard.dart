import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/bottom_navigation/js_my_jobs_page.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/bottom_navigation/js_profile_page.dart';
import 'bottom_navigation/home.dart';
class NHomePage extends StatefulWidget {
  const NHomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<NHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const JobSeekerHomePage(),
    const MyJobsPage(),
    const JsProfilePage(),
  ];

  void navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor:
        const Color(0xff2597F1),

        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                SizedBox(
                  height: 200,
                  width: constraints.maxWidth * 0.2, // 20% of screen width
                  child: Image.asset("assets/sirf_logo.png",),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 20, top: 20, bottom: 20),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search',
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share))
              ],
            );
          },
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.white70,
          backgroundColor: const Color(0xff1C4374),
          currentIndex: _currentIndex,
          iconSize: 30,
          onTap: navigateTo,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.document_scanner_outlined),
                label: 'My Applications'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
          selectedItemColor: const Color(0xFF2597F1),
          unselectedLabelStyle:
              TextStyle(color: Colors.white10.withOpacity(0.5)),
          selectedLabelStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    ));
  }
}