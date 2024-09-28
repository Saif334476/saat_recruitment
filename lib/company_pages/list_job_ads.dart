import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'company_new_ad_posting.dart';

class JobAdsListView extends StatefulWidget {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  JobAdsListView({super.key});

  @override
  _JobAdsListViewState createState() => _JobAdsListViewState();
}

class _JobAdsListViewState extends State<JobAdsListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          height: 500,
          color: Colors.transparent,
          child: Expanded(
            child: snapshot.data!.docs.isEmpty
                ? const Center(child: Text('No job ads found'))
                : ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot jobAdDoc = snapshot.data!.docs[index];

                      return ListTile(
                        onTap: () async {
                          final jobAdId = (jobAdDoc.id);
                          final jobAdData =
                              jobAdDoc.data() as Map<String, dynamic>;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyNewAdPosting(
                                jobAdData: jobAdData,
                                jobAdId: jobAdId,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          jobAdDoc['jobTitle'],
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      "Location: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(jobAdDoc['location']),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
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
