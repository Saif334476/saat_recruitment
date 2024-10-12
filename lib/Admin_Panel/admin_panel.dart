import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Admin_Panel/preview_doc.dart';
import '../login_page.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  AdminPanelState createState() => AdminPanelState();
}

class AdminPanelState extends State<AdminPanel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<JobProvider> _jobProviders = [];

  @override
  void initState() {
    super.initState();
    _fetchJobProviders();
  }

  _fetchJobProviders() async {
    try {
      final querySnapshot = await _firestore
          .collection('Users')
          .where('role', isEqualTo: 'JobProvider')
          .where('isActive', isEqualTo: false)
          .where('isComplete', isEqualTo: true)
          .get();

      setState(() {
        _jobProviders = querySnapshot.docs.map((doc) {
          return JobProvider(
              id: doc.id,
              name: doc.get('Name'),
              industry: doc.get('Industry'),
              location: doc.get('Location'),
              docs: doc.get('legalDocs'),
              email: doc.get('Email'));
        }).toList();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff1C4374),
        title: const Text(
          "Admin Panel",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                'Admin Panel',
                style: TextStyle(
                    color: Color(0xff1C4374),
                    fontSize: 24,
                    fontWeight: FontWeight.w900),
              ),
            ),
            const Divider(height: 10),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.logout_outlined),
                  Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            const Divider(height: 10),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text(
              'List of job providers awaiting verification',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _jobProviders.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _jobProviders.length,
                    itemBuilder: (context, index) {
                      final jobProvider = _jobProviders[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreviewDoc()));
                        },
                        child: Card(
                          color: Colors.white12,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Name: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(jobProvider.name.toUpperCase())
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Location: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(jobProvider.location.toUpperCase())
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Email: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(jobProvider.email)
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Industry: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(jobProvider.industry.toUpperCase())
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class JobProvider {
  String id;
  String name;
  String industry;
  String location;
  String docs;
  String email;

  JobProvider(
      {required this.id,
      required this.name,
      required this.industry,
      required this.docs,
      required this.location,
      required this.email});
}
