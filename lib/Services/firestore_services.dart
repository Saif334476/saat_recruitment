import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveJobSeekerData(String uid, Map<String, dynamic> jobSeekerData) async {
    try {
      await _db.collection('Users').doc(uid).set(jobSeekerData, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to save job seeker data: $e");
    }
  }
}
