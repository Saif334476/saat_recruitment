import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/job_info.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // clipBehavior: Clip.antiAlias,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(20) ,
        //     topRight:  Radius.circular(20),
        //     bottomLeft: Radius.circular(20),
        //     bottomRight: Radius.circular(20),
        //   ),
        //   side: BorderSide(
        //     color: Color(0xff1C4374),
        //     width: 2,
        //   ),
        // ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                SizedBox(
                  height: 200,
                  width: constraints.maxWidth * 0.2, // 20% of screen width
                  child: Image.asset(
                    "assets/sirf_logo.png",
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 230,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 20, top: 5, bottom: 5),
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
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share_outlined,
                    ))
              ],
            );
          },
        ),
      ),
      body: Center(
          child: Column(children: [
        Container(
            decoration: const BoxDecoration(color: Colors.white
                // gradient: LinearGradient(
                //     colors: [Colors.blue, Colors.white],
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter),
                ),
            // color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      JobCategories(
                        jobCategories: jobCategories,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                      JobsWidget(selectedCategory: _selectedCategory),
                    ])))
      ])),
    );
  }
}

class JobsWidget extends StatelessWidget {
  final String selectedCategory;

  const JobsWidget({super.key, required this.selectedCategory});

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
        return Container(
          height: 579,
          color: Colors.transparent,
          child: Expanded(
            child: snapshot.data!.docs.isEmpty
                ? const Center(
                    child: Text('No job ads found for selected category'))
                : ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot jobAdDoc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0, left: 15),
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
                            onTap: () async {
                              final jobAdData =
                                  jobAdDoc.data() as Map<String, dynamic>;
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
                                  ); // Your full-page modal widget
                                },
                              );
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      jobAdDoc['jobTitle'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ),
                                    FutureBuilder(
                                      future: companyName(jobAdDoc['postedBy']),
                                      builder: (context, snapshot) {
                                        return Text(
                                          snapshot.data?['Name'] ??
                                              "---", // assuming 'companyName' is the field in Firestore
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Location: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(jobAdDoc['location']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Salary: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(jobAdDoc['salary']),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
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
                                        Text(jobAdDoc['requiredExperience']),
                                      ],
                                    ),
                                  ],
                                ),
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
                  ),
          ),
        );
      },
    );
  }
}
