import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicantsOnAd extends StatefulWidget {
  final String jobAdId;
  final String resumeUrl;
  const ApplicantsOnAd({super.key, required this.jobAdId, required this.resumeUrl});

  @override
  State<ApplicantsOnAd> createState() => _ApplicantsOnAdState();
}

class _ApplicantsOnAdState extends State<ApplicantsOnAd> {

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('jobs').doc(widget.jobAdId).collection("Applicants").doc(widget.jobAdId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const Center(child: Text('No data found'));
          }

          DocumentSnapshot applicantDetail = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.separated(
                itemCount: 1, // You're only displaying one document
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: const Color(0xff1C4374), width: 1.5)),
                      child: ListTile(
                        onTap: () async {
                          // final jobAdId = (jobAdDoc.id);
                          // final jobAdData =
                          // jobAdDoc.data() as Map<String, dynamic>;
                          //
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CompanyNewAdPosting(
                          //       jobAdData: jobAdData,
                          //       jobAdId: jobAdId,
                          //     ),
                          //   ),
                          // );
                        },
                        title: Text(
                          applicantDetail['applicantId'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17),
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