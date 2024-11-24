import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/JobProvider%20Pages/JP%20Nav%20Bar/Nav%20Items/Job%20Ads%20Listing/show_resume.dart';

class ApplicantsOnAd extends StatefulWidget {
  final String jobAdId;

  const ApplicantsOnAd({super.key, required this.jobAdId});

  @override
  State<ApplicantsOnAd> createState() => _ApplicantsOnAdState();
}

class _ApplicantsOnAdState extends State<ApplicantsOnAd> {
  Future<QuerySnapshot<Map<String, dynamic>>> applicants() {
    return FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobAdId)
        .collection('Applicants')
        .get(); // Fetch applicants
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C4374),
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.center,
          child: Text("APPLICANTS",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                  color: Colors.white)),
        ),
      ),
      body: FutureBuilder(
        future: applicants(), // Fetch applicants using the future
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot) {
          if (!snapShot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapShot.data!.docs.isEmpty) {
            return const Center(child: Text('No applicants found.'));
          }

          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.separated(
                itemCount: snapShot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot applicantDetail = snapShot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: const Color(0xff1C4374), width: 1.5)),
                      child: ListTile(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowResume(
                                      resumeUrl:
                                          applicantDetail['resumeUrl'])));
                        },
                        title: Text(
                          applicantDetail['applicantEmail'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
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
