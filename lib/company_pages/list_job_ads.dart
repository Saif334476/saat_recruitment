import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> fetchCompanyInfo(String uid) async {
  final doc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Job Ads')
      .get();

  return doc.docs.map((doc) => doc.data()).toList();
}

class JobAdsListView extends StatefulWidget {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  JobAdsListView({super.key});

  @override
  _JobAdsListViewState createState() => _JobAdsListViewState();
}

class _JobAdsListViewState extends State<JobAdsListView> {
  List<Map<String, dynamic>>? _jobAds;
  bool _isLoading = true;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
    fetchCompanyInfo(uid.toString()).then((value) {
      setState(() {
        _jobAds = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 500,
      color: Colors.transparent,
      child: Expanded(
        child: ListView.separated(
          itemCount: _jobAds!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _jobAds?[index]['Title'],
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
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(_jobAds?[index]['JobType']),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Location: ",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(_jobAds?[index]['JobLocation'])
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
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(_jobAds?[index]["RequiredExperience"]),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Salary: ",style: TextStyle(fontWeight: FontWeight.w700),),
                          Text(_jobAds?[index]["Salary"])
                        ],
                      )
                    ],
                  )
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
  }
}
