import 'package:saat_recruitment/job_seeker_pages/job_seeker_profile.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/js_my_jobs_page.dart';
import 'package:saat_recruitment/job_seeker_pages/js_profile_page.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';

class NHomePage extends StatefulWidget {
  const NHomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<NHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
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

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController searchController = TextEditingController();

  final List<JobCategory> jobCategories = [
    JobCategory(icon: Icons.computer, name: 'IT & Technology'),
    JobCategory(icon: Icons.local_hospital, name: 'Healthcare'),
    JobCategory(icon: Icons.shopping_cart, name: 'Sales & Marketing'),
    JobCategory(icon: Icons.account_balance, name: 'Finance & Accounting'),
    JobCategory(icon: Icons.headset_mic, name: 'Customer Service'),
    JobCategory(icon: Icons.people, name: 'Administration & HR'),
    JobCategory(icon: Icons.construction, name: 'Engineering & Manufacturing'),
    JobCategory(icon: Icons.brush, name: 'Creative & Design'),
    JobCategory(icon: Icons.hotel, name: 'Hospitality & Tourism'),
    JobCategory(icon: Icons.school, name: 'Education & Training'),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
        Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            // color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, top: 0, right: 10, left: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff1C4374)),
                                gradient: const LinearGradient(
                                    colors: [Color(0xff57a9f3), Colors.white],
                                    begin: Alignment(0, 5),
                                    end: Alignment(4, 2.8)),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xff1C4374),
                                      blurRadius: 5,
                                      blurStyle: BlurStyle.outer),
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            height: 95.5,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: jobCategories.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 6,
                                          right: 6),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xff1C4374)),
                                          // color: const Color(0xff6ab0ec),
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xff57a9f3),
                                                Colors.white
                                              ],
                                              begin: Alignment(0, 5.2),
                                              end: Alignment(4, 2.8)),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black54,
                                                blurRadius: 3,
                                                blurStyle: BlurStyle.outer),
                                          ],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 40,
                                              width: 80,
                                              child: ListTile(
                                                  leading: SizedBox(
                                                width: 10,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Icon(
                                                      jobCategories[index]
                                                          .icon),
                                                ),
                                              ))),
                                          Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child: Text(
                                                jobCategories[index].name,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                }),
                          )),
                      Expanded(
                        child: ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 15,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, right: 10, left: 10),
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xff1C4374)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color(0xff1C4374),
                                            blurRadius: 6.5,
                                            blurStyle: BlurStyle.outer),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: const ListTile(
                                      leading: Icon(Icons.computer_outlined),
                                      title: Text(
                                        "Flutter Developer",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      subtitle: Column(
                                        //      mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6),
                                                child: Text(
                                                  'SAAT Softs',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                          Row(children: [
                                            Icon(Icons.location_on_outlined),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Jhang,Satellite Town',
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ]),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Text(
                                                '40,000-50000 PKR',
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )));
                          },
                        ),
                      )
                    ]))));
  }
}

class JobCategory {
  final IconData icon;
  final String name;

  JobCategory({required this.icon, required this.name});
}
