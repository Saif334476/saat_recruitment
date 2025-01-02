import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class MyJobsPage extends StatefulWidget {
  const MyJobsPage({super.key});

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  String _selectedButton = "";
  String uId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _selectedButton = "All";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xff1C4374)),
                  foregroundColor:
                      WidgetStateProperty.all(const Color(0xff1C4374)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side:
                          const BorderSide(width: 2, color: Color(0xff1C4374)),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedButton = "All"; // Update selectedButton to "All"
                  });
                },
                child: Text(
                  "All",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: _selectedButton == "All"
                        ? const Color(0xFF97C5FF)
                        : Colors.white, // Change color based on selection
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xff1C4374)),
                  foregroundColor:
                      WidgetStateProperty.all(const Color(0xff1C4374)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side:
                          const BorderSide(width: 2, color: Color(0xff1C4374)),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedButton = "Successful";
                  });
                },
                child: Text(
                  'Successful',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: _selectedButton == "Successful"
                          ? const Color(0xFF97C5FF)
                          : Colors.white),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xff1C4374)),
                  foregroundColor:
                      WidgetStateProperty.all(const Color(0xff1C4374)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side:
                          const BorderSide(width: 2, color: Color(0xff1C4374)),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedButton = "UnSuccessful";
                  });
                },
                child: Text("UnSuccessful",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: _selectedButton == "UnSuccessful"
                            ? const Color(0xFF97C5FF)
                            : Colors.white)),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uId)
                  .collection("Job Applications")
                  .where('applicationStatus',
                      isEqualTo:
                          _selectedButton == "All" ? null : _selectedButton)
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
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          jobAdDoc['jobTitle'] ?? 'No Title',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        // child: Text(
                                        //   jobAdDoc['companyName'] ?? "---",
                                        //   overflow: TextOverflow.ellipsis,
                                        //   style: const TextStyle(
                                        //       fontWeight: FontWeight.w600),
                                        // ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.location_on_outlined),
                                          SizedBox(
                                              width: 100,
                                              child: Text(
                                                jobAdDoc['location'] ?? 'N/A',
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "PKR:",
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
                              subtitle: Column(
                                children: [
                                  Row(
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
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Text(
                                                  jobAdDoc['jobType'] ?? 'N/A'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Req. Experience: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Text(jobAdDoc[
                                                      'requiredExperience'] ??
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
                                            icon: const Icon(
                                                Icons.share_outlined),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(uId)
                                                  .collection(
                                                      "Job Applications")
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
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color(0xff1C4374))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        applicationDoc["applicationStatus"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  )
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
