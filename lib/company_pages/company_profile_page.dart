import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/login_page.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

Future<Map<String, dynamic>?> fetchCompanyInfo(String uid) async {
  final doc = await FirebaseFirestore.instance
      .collection('JobProviders')
      .doc(uid)
      .get();

  return doc.data();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Map<String, dynamic>? companyInfo;

  @override
  void initState() {
    super.initState();
    fetchCompanyInfo(uid!).then((info) {
      setState(() {
        companyInfo = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: companyInfo != null
          ? displayCompanyInfo(companyInfo!, context)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

Widget displayCompanyInfo(
    Map<String, dynamic> companyInfo, BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.blue, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: Image.asset(
                    FirebaseAuth.instance.currentUser!.photoURL.toString())),
          ),
          ListTile(
            title: Row(
              children: [
                const Divider(
                  height: 5,
                ),
                const Text(
                  'Name: ',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1C4374)),
                ),
                Text(
                  companyInfo['Name'].toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 23,
                      color: Colors.white),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.black))
              ],
            ),
            onTap: () {},
          ),
          const Divider(
            height: 5,
          ),
          ListTile(
            title: Row(
              children: [
                const Text(
                  'E-mail: ',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1C4374)),
                ),
                Text(
                  companyInfo['Email'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                )
              ],
            ),
            onTap: () {},
          ),
          const Divider(
            height: 5,
          ),
          ListTile(
            title: Row(
              children: [
                const Text(
                  'Industry: ',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1C4374)),
                ),
                Text(
                  companyInfo['Industry'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                )
              ],
            ),
            onTap: () {},
          ),
          const Divider(
            height: 5,
          ),
          ListTile(
            title: Row(
              children: [
                const Text(
                  'Location: ',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1C4374)),
                ),
                Text(
                  companyInfo['Location'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_location, color: Colors.black))
              ],
            ),
            onTap: () {},
          ),
          const Divider(
            height: 5,
          ),
          ListTile(
            title: Row(
              children: [
                const Text(
                  'Company Size: ',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1C4374)),
                ),
                Text(
                  companyInfo['CompanySize'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ))
              ],
            ),
            onTap: () {},
          ),
          const Divider(
            height: 5,
          ),
          ListTile(
            title: const Text(
              'Privacy & Security',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            onTap: () {
              // Handle item 1 tap
            },
          ),
          const Divider(
            height: 15,
          ),
          ListTile(
            title: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: Colors.black,
                    )),
                const Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
          const Divider(
            height: 5,
          ),
          // Add more fields as needed
        ],
      ),
    ),
  );
}
