import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/Admin_Panel/preview_doc.dart';
import 'package:saat_recruitment/Models/job_provider.dart';
import 'package:saat_recruitment/Services/firestore_services.dart';
import '../login_page.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  AdminPanelState createState() => AdminPanelState();
}

class AdminPanelState extends State<AdminPanel> {
  FirestoreService firestoreService = FirestoreService();
  // Future<void> _fetchJobProviders() async {
  //
  //   List<JobProviderModel> jobProviders =
  //     //  await firestoreService.getJobProvidersAwaitingVerification();
  //   setState(() {
  //     _jobProviders = jobProviders;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //  _fetchJobProviders();
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
        body: StreamBuilder<List<JobProviderModel>>(
            stream: firestoreService.getJobProvidersAwaitingVerification(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final jobProviders = snapshot.data;

              if (jobProviders == null || jobProviders.isEmpty) {
                return const Center(
                  child: Text('No job providers awaiting verification.'),
                );
              }

              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Job providers awaiting for verification',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    color: Color(0xff1C4374),
                    thickness: 1.5,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: jobProviders.length,
                      itemBuilder: (context, index) {
                        final jobProvider = jobProviders[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PreviewDoc(
                                          url: jobProvider.docUrl,
                                          id: jobProvider.id,
                                        )));
                          },
                          child: Card(
                            color: const Color(0xff1C4374),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person_outline_sharp,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Text(
                                              " ${jobProvider.name.toUpperCase()}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Industry: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30,
                                            child: Text(
                                              jobProvider.industry
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          " ${jobProvider.email}",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          jobProvider.location.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      )
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
              );
            }));
  }
}
