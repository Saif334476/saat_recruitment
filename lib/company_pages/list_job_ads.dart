import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'company_new_ad_posting.dart';

class JobAdsListView extends StatefulWidget {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  JobAdsListView({super.key});

  @override
  JobAdsListViewState createState() => JobAdsListViewState();
}

class JobAdsListViewState extends State<JobAdsListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where('postedBy', isEqualTo: widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return snapshot.data!.docs.isEmpty
            ? const Center(
                child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'No job ads found',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ))
            : Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot jobAdDoc = snapshot.data!.docs[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: const Color(0xff1C4374),width: 1.5)),
                          child: ListTile(
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
                            title: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobAdDoc['jobTitle'],
                                      style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 17),
                                    ),
                                    IconButton(onPressed: (){}, icon: const Icon(Icons.share_outlined))
                                  ],
                                ),
                                const Divider(color: Color(0xff1C4374),)
                              ],
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
                                              fontWeight: FontWeight.w700,fontSize: 17),
                                        ),
                                        Text(jobAdDoc['jobType']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Location: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,fontSize: 17),
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
                                              fontWeight: FontWeight.w700,fontSize: 17),
                                        ),
                                        Text(jobAdDoc['requiredExperience']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Salary: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,fontSize: 17),
                                        ),
                                        Text(jobAdDoc['salary']),
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
