import 'package:flutter/material.dart';
import 'bottom_navigation/home.dart';
import 'bottom_navigation/js_my_jobs_page.dart';
import 'bottom_navigation/js_profile_page.dart';


class JsBottomNavigationBar extends StatefulWidget {
  const JsBottomNavigationBar({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<JsBottomNavigationBar> {
  int _currentIndex = 0;
  late PageController _pageController;
  final List<Widget> _children = [
    const JobSeekerHomePage(),
    const MyJobsPage(),
    const JsProfilePage(),
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
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
          children: _children,
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
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.document_scanner_outlined),
                    label: 'My Applications'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
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