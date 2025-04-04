import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/job_info.dart';

import 'package:share_plus/share_plus.dart';
import 'job_categories.dart';

class JobSeekerHomePage extends StatefulWidget {
  final String? selectedCategory;
  const JobSeekerHomePage({super.key, this.selectedCategory});

  @override
  State<JobSeekerHomePage> createState() => _JobSeekerHomePageState();
}

class _JobSeekerHomePageState extends State<JobSeekerHomePage> {
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
    JobCategory(icon: Icons.devices_other_rounded, name: 'Other Jobs'),
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    height: 80,
                    width: 80,
                    "assets/sirf_logo.png",
                    fit: BoxFit.fill,
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.6,
                  //   child: textFormField("Search", Icons.search, false,
                  //       onChanged: ,
                  //       keyboard: TextInputType.text,
                  //       controller: _searchController, validator: (ting) {
                  //     return null;
                  //   }),
                  // ),
                  const Text(
                    "SAAT",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        fontFamily: "Georgia"),
                  ),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.info,
                          size: 35,
                        )),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            JobCategories(
              jobCategories: jobCategories,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const Divider(
              height: 0,
              color: Color(0xff1C4374),
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            JobsWidget(
              selectedCategory: _selectedCategory,
              jobCategories: jobCategories,
            ),
          ]),
        ),
      ),
    );
  }
}

class JobsWidget extends StatelessWidget {
  final String selectedCategory;
  final List<JobCategory> jobCategories;
  const JobsWidget(
      {super.key, required this.selectedCategory, required this.jobCategories});

  Future<DocumentSnapshot<Map<String, dynamic>>> companyName(name) async {
    final named =
        await FirebaseFirestore.instance.collection('Users').doc(name).get();
    return named;
  }

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
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: snapshot.data!.docs.isEmpty
                ? const Center(
                    child: Text('No job ads found for selected category'))
                : ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot jobAdDoc = snapshot.data!.docs[index];
                      String category = jobAdDoc['selectedCategory'];
                      IconData categoryIcon = Icons.help_outline;
                      JobCategory? categoryItem = jobCategories.firstWhere(
                        (categoryObj) => categoryObj.name == category,
                        orElse: () => JobCategory(
                            icon: Icons.help_outline, name: 'Unknown'),
                      );
                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0, left: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff1C4374)),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xff1C4374),
                                  blurRadius: 6.5,
                                  blurStyle: BlurStyle.outer),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ListTile(
                            leading: Icon(categoryItem.icon),
                            onTap: () async {
                              final jobAdData = jobAdDoc.data() as Map<String, dynamic>;
                              final jobAdId = snapshot.data!.docs[index].id;
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: 'Dismiss',
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration:
                                    const Duration(milliseconds: 400),
                                pageBuilder: (context, anim1, anim2) {
                                  return JobInfo(
                                    jobAdData: jobAdData,
                                    jobAdId: jobAdId,
                                  );
                                },
                              );
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        jobAdDoc['jobTitle'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: companyName(jobAdDoc['postedBy']),
                                      builder: (context, snapshot) {
                                        return Row(
                                          children: [
                                            const Icon(Icons.corporate_fare),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.3,
                                              child: Text(
                                                snapshot.data?['Name'] ?? "---",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.location_on_outlined),
                                        SizedBox(
                                            width: 100,
                                            child: Text(
                                              jobAdDoc['location'],
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "PKR. ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(jobAdDoc['salary'],
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Job Type: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(jobAdDoc['jobType']),
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
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                                jobAdDoc['requiredExperience']),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      Share.share(
                                          'Check out this job opportunity: ${jobAdDoc['jobTitle']}\nApply now:https://final-project2000202.firebaseapp.com/jobs/${jobAdDoc.id}');
                                    },
                                    icon: const Icon(Icons.share_outlined))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 8,
                        color: Colors.transparent,
                      );
                    },
                  ));
      },
    );
  }
}
