import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'package:share/share.dart';
import '../job_info.dart';

class MyJobsPage extends StatefulWidget {
  const MyJobsPage({super.key});

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  String selectedButton = "Successful";
  String uId = FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

  @override
  void initState() {
    super.initState();
    selectedButton = "Successful"; // Default filter to "Successful"
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

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(jobId)
                          .snapshots(),
                      builder: (context, jobSnapshot) {
                        if (jobSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!jobSnapshot.hasData || !jobSnapshot.data!.exists) {
                          return Center(
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: const Color(0xff1C4374))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                        'Job not found or has been deleted'),
                                  )));
                        }

                        DocumentSnapshot jobAdDoc = jobSnapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              onTap: () async {},
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        jobAdDoc['jobTitle'] ?? 'No Title',
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
                                          Text(jobAdDoc['location'] ?? 'N/A'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Salary: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(jobAdDoc['salary'] ?? 'N/A'),
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
                                          Text(jobAdDoc['jobType'] ?? 'N/A'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Req. Experience: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(jobAdDoc['requiredExperience'] ??
                                              'N/A'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Share.share(
                                              'Check out this job opportunity: ${jobAdDoc['jobTitle']}\nApply now:https://final-project2000202.firebaseapp.com/jobs/${jobAdDoc.id}');
                                        },
                                        icon: const Icon(Icons.share_outlined),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(uId)
                                              .collection("Job Applications")
                                              .doc(jobAdDoc.id)
                                              .delete();
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
