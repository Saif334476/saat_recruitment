import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import '../job_info.dart';

class MyJobsPage extends StatefulWidget {
  const MyJobsPage({super.key});

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  String selectedButton = "";
  String uId = FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

  @override
  void initState() {
    super.initState();
    selectedButton = "Successful";
  }

  Future<DocumentSnapshot> fetchJobDetails(String jobId) async {
    return FirebaseFirestore.instance.collection('jobs').doc(jobId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                elevatedButtons(
                  onPressed: () {
                    setState(() {
                      selectedButton = "Successful"; // Set to "Successful"
                    });
                  },
                  widget: const Text(
                    'Successful',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                ),
                elevatedButtons(
                  onPressed: () {
                    setState(() {
                      selectedButton = "UnSuccessful"; // Set to "UnSuccessful"
                    });
                  },
                  widget: const Text("UnSuccessful",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.white)),
                ),
                elevatedButtons(
                  onPressed: () {
                    setState(() {
                      selectedButton = "All"; // Set to "All"
                    });
                  },
                  widget: const Text("All",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uId)
                  .collection("Job Applications")
                  .where('applicationStatus', isEqualTo: "Successful")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text(
                    'No applications to show...',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ));
                }

                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot applicationDoc =
                        snapshot.data!.docs[index];
                    String jobId = applicationDoc.id;

                    return FutureBuilder<DocumentSnapshot>(
                      future: fetchJobDetails(jobId), // Fetch job details
                      builder: (context, jobSnapshot) {
                        if (!jobSnapshot.hasData) {
                          return const Center(
                              child: SizedBox());
                        }

                        DocumentSnapshot jobAdDoc = jobSnapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff1C4374)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xff1C4374),
                                  blurRadius: 6.5,
                                  blurStyle: BlurStyle.outer,
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: ListTile(
                              onTap: () async {
                                // final jobAdData =
                                //     jobAdDoc.data() as Map<String, dynamic>;
                                // final jobAdId =
                                //     jobAdDoc.id; // Get the job document ID
                                // showGeneralDialog(
                                //   context: context,
                                //   barrierDismissible: true,
                                //   barrierLabel: 'Dismiss',
                                //   barrierColor: Colors.black.withOpacity(0.5),
                                //   transitionDuration:
                                //       const Duration(milliseconds: 400),
                                //   pageBuilder: (context, anim1, anim2) {
                                //     return JobInfo(
                                //       jobAdData: jobAdData,
                                //       jobAdId: jobAdId,
                                //     );
                                //   },
                                // );
                              },
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        jobAdDoc['jobTitle'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w900),
                                      ),
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
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.share_outlined)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 5,); },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
