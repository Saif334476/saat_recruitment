import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../company_pages/company_new_ad_posting.dart';

class JobSeekerHomePage extends StatefulWidget {
  const JobSeekerHomePage({super.key});

  @override
  State<JobSeekerHomePage> createState() => _JobSeekerHomePageState();
}

class _JobSeekerHomePageState extends State<JobSeekerHomePage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
        child: Column(children: [
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
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 0, right: 10, left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff1C4374)),
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
                                    top: 10, bottom: 10, left: 6, right: 6),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 40,
                                        width: 80,
                                        child: ListTile(
                                            leading: SizedBox(
                                          width: 10,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child:
                                                Icon(jobCategories[index].icon),
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
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          }),
                    )),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('jobs')
                      .where('selectedCategory', isEqualTo: "Administration & HR")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      height: 600,
                      color: Colors.transparent,
                      child: Expanded(
                        child: snapshot.data!.docs.isEmpty
                            ? const Center(child: Text('No job ads found'))
                            : ListView.separated(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot jobAdDoc =
                                      snapshot.data!.docs[index];

                                  return ListTile(
                                    onTap: () async {
                                      final jobAdId = (jobAdDoc.id);
                                      final jobAdData = jobAdDoc.data()
                                          as Map<String, dynamic>;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CompanyNewAdPosting(
                                            jobAdData: jobAdData,
                                            jobAdId: jobAdId,
                                          ),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      jobAdDoc['jobTitle'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Job Type: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(jobAdDoc['jobType']),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Location: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(jobAdDoc['location']),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Req. Experience: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(jobAdDoc[
                                                    'requiredExperience']),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Salary: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(jobAdDoc['salary']),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    height: 2,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                      ),
                    );
                  },

                  // Expanded(
                  //   child: ListView.builder(
                  //     physics: const ScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: 15,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Padding(
                  //           padding: const EdgeInsets.only(
                  //               bottom: 8, right: 10, left: 10),
                  //           child: Container(
                  //               decoration: BoxDecoration(
                  //                 border: Border.all(
                  //                     color: const Color(0xff1C4374)),
                  //                 boxShadow: const [
                  //                   BoxShadow(
                  //                       color: Color(0xff1C4374),
                  //                       blurRadius: 6.5,
                  //                       blurStyle: BlurStyle.outer),
                  //                 ],
                  //                 borderRadius: const BorderRadius.all(
                  //                     Radius.circular(10)),
                  //               ),
                  //               child: const ListTile(
                  //                 leading: Icon(Icons.computer_outlined),
                  //                 title: Text(
                  //                   "Flutter Developer",
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 18),
                  //                 ),
                  //                 subtitle: Column(
                  //                   //      mainAxisAlignment: MainAxisAlignment.start,
                  //                   children: [
                  //                     Align(
                  //                         alignment: Alignment.centerLeft,
                  //                         child: Padding(
                  //                           padding:
                  //                               EdgeInsets.only(left: 6),
                  //                           child: Text(
                  //                             'SAAT Softs',
                  //                             textAlign: TextAlign.start,
                  //                             style: TextStyle(
                  //                                 fontWeight:
                  //                                     FontWeight.bold),
                  //                           ),
                  //                         )),
                  //                     Row(children: [
                  //                       Icon(Icons.location_on_outlined),
                  //                       Align(
                  //                         alignment: Alignment.centerLeft,
                  //                         child: Text(
                  //                           'Jhang,Satellite Town',
                  //                           textAlign: TextAlign.left,
                  //                         ),
                  //                       ),
                  //                     ]),
                  //                     Align(
                  //                       alignment: Alignment.centerLeft,
                  //                       child: Padding(
                  //                         padding: EdgeInsets.only(left: 6),
                  //                         child: Text(
                  //                           '40,000-50000 PKR',
                  //                           textAlign: TextAlign.left,
                  //                         ),
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //               )));
                  //     },
                  //   ),
                  // )
                )
              ])))
    ]));
  }
}

class JobCategory {
  final IconData icon;
  final String name;

  JobCategory({required this.icon, required this.name});
}
