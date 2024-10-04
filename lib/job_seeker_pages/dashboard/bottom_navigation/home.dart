import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../company_pages/company_new_ad_posting.dart';
import 'job_categories.dart';

class JobSeekerHomePage extends StatefulWidget {
  final String? selectedCategory;
  const JobSeekerHomePage({super.key, this.selectedCategory});

  @override
  State<JobSeekerHomePage> createState() => _JobSeekerHomePageState();
}

class _JobSeekerHomePageState extends State<JobSeekerHomePage> {
  final TextEditingController searchController = TextEditingController();
  String _selectedCategory = "IT & Technology";
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
                    JobCategories(
                      jobCategories: jobCategories,
                      onCategorySelected: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                    JobsWidget(selectedCategory: _selectedCategory),



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

              ])))
    ]));
  }
}


class JobsWidget extends StatelessWidget {
  final String selectedCategory;

  const JobsWidget({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where('selectedCategory', isEqualTo: selectedCategory)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          height: 579,
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
    );
  }
}
