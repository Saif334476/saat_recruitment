import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saat_recruitment/Models/job_provider.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveJobSeekerData(
      String uid, Map<String, dynamic> jobSeekerData) async {
    try {
      await _db
          .collection('Users')
          .doc(uid)
          .set(jobSeekerData, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to save job seeker data: $e");
    }
  }

  Future<void> uploadProfilePicUrl(uid, profilePicUrl) async {
    await _db.collection("Users").doc(uid).update({
      "profilePicUrl": profilePicUrl,
    });
  }

  Future<void> uploadResumeUrl(uid, profilePicUrl) async {
    await _db.collection("Users").doc(uid).update({
      "resumeUrl": profilePicUrl,
    });
  }

  Future<bool> checkApplicantStatus(String uid, String jobAdId) async {
    DocumentSnapshot applicant = await _db
        .collection('jobs')
        .doc(jobAdId)
        .collection("Applicants")
        .doc(uid)
        .get();
    return applicant.exists;
  }

  Future<void> saveApplicationAtJS(
      String jobAdId, String uid, String status) async {
    try {
      await _db
          .collection('Users')
          .doc(uid)
          .collection("Job Applications")
          .doc(jobAdId)
          .set({"applicationStatus": status}, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to upload application: $e");
    }
  }

  Future<void> sendApplicantDataToJP(
      String jobAdId, String uid, String resumeUrl, email) async {
    try {
      await _db
          .collection('jobs')
          .doc(jobAdId)
          .collection("Applicants")
          .doc(uid)
          .set({
        'applicantId': uid,
        'resumeUrl': resumeUrl,
        'applicantEmail': email
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to upload application: $e");
    }
  }

  Future<void> saveJobProviderData(
      String uid, Map<String, dynamic> jobProviderData) async {
    try {
      await _db
          .collection('Users')
          .doc(uid)
          .set(jobProviderData, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to save job seeker data: $e");
    }
  }

  Future<List<JobProviderModel>> getJobProvidersAwaitingVerification() async {
    List<JobProviderModel> jobProviders = [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('role', isEqualTo: 'JobProvider')
        .where('isActive', isEqualTo: false)
        .where('isComplete', isEqualTo: true)
        .get();
    jobProviders = querySnapshot.docs.map((doc) {
      return JobProviderModel.fromMap(doc.data());
    }).toList();

    return jobProviders;
  }

}
