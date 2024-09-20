import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  AdminPanelState createState() => AdminPanelState();
}

class AdminPanelState extends State<AdminPanel> {
  final List<JobProvider> _jobProviders = [
    JobProvider(
      id: 1,
      name: 'Job Provider 1',
      documentType: 'Tax Certificate',
      documentStatus: 'Pending',
    ),
    JobProvider(
      id: 2,
      name: 'Job Provider 2',
      documentType: 'Registration Form',
      documentStatus: 'Pending',
    ),
    JobProvider(
      id: 3,
      name: 'Job Provider 3',
      documentType: 'Other',
      documentStatus: 'Pending',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white,
          gradient: LinearGradient(
              colors: [Colors.white, Colors.blue],
              begin: Alignment(2.5,0.33),
              end: Alignment(0.2,1.75)),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: SizedBox(
                    height: 150,
                    child: Image.asset("assets/admin.webp")),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  'List of job providers awaiting verification',
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _jobProviders.length,
                  itemBuilder: (context, index) {
                    final jobProvider = _jobProviders[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${jobProvider.name}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Document Type: ${jobProvider.documentType}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Document Status: ${jobProvider.documentStatus}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Call API to verify job provider
                                    // ...
                                    setState(() {
                                      jobProvider.documentStatus = 'Verified';
                                    });
                                  },
                                  child: const Text('Verify'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // Call API to reject job provider
                                    // ...
                                    setState(() {
                                      jobProvider.documentStatus = 'Rejected';
                                    });
                                  },
                                  child: const Text('Reject'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobProvider {
  int id;
  String name;
  String documentType;
  String documentStatus;

  JobProvider({required this.id, required this.name, required this.documentType, required this.documentStatus});
}