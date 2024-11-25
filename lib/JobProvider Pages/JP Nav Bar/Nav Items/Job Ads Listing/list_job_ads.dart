import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/JobProvider%20Pages/JP%20Nav%20Bar/Nav%20Items/Job%20Ads%20Listing/applicants_on_ad.dart';
import 'package:share/share.dart';
import '../Ad Posting/new_ad_posting.dart';

class JobAdsListView extends StatefulWidget {
  const JobAdsListView({super.key});

  @override
  JobAdsListViewState createState() => JobAdsListViewState();
}

class JobAdsListViewState extends State<JobAdsListView> {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.77,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('postedBy', isEqualTo: uid)
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
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: const Color(0xff1C4374),
                                    width: 1.5)),
                            child: ListTile(
                              onLongPress: () async {
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 230,
                                        child: Text(
                                          jobAdDoc['jobTitle'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      Row(

                                      children: [
                                          IconButton(
                                              onPressed: () {Share.share('Check out this job opportunity: ${jobAdDoc['jobTitle']}\nApply now:https://final-project2000202.firebaseapp.com/jobs/${jobAdDoc.id}');},
                                              icon: const Icon(
                                                  Icons.share_outlined)),
                                          IconButton(
                                              onPressed: () async{
                                                await FirebaseFirestore.instance
                                                    .collection("jobs")
                                                    .doc(jobAdDoc.id)
                                                    .delete();
                                              },
                                              icon: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.redAccent,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    color: Color(0xff1C4374),
                                  )
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
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17),
                                          ),
                                          Text(jobAdDoc['jobType']),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Location: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17),
                                          ),
                                          Text(jobAdDoc['location']),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Req. Experience: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17),
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
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17),
                                              ),
                                              Text(jobAdDoc['salary']),
                                            ],
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ApplicantsOnAd(
                                                          jobAdId:
                                                              jobAdDoc.id)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color:
                                                      const Color(0xff1C4374)),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Applicants:${jobAdDoc['numberOfApplicants']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17),
                                            ),
                                          ),
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
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
