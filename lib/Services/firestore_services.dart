import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saat_recruitment/Models/job_provider.dart';

import '../Models/job.dart';

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
        .collection('Users')
        .doc(uid)
        .collection("Job Applications")
        .doc(jobAdId)
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

  Stream<List<JobProviderModel>> getJobProvidersAwaitingVerification() {
    return _db
        .collection('Users')
        .where('role', isEqualTo: 'JobProvider')
        .where('isActive', isEqualTo: false)
        .where('isComplete', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return JobProviderModel.fromMap(doc.data());
    }).toList());
  }

  Future<void> updateJob(String jobAdId, Map<String, dynamic> job) async {
    if (jobAdId.isNotEmpty && job.isNotEmpty) {
      await _db.collection("jobs").doc(jobAdId).set(
            job,
            SetOptions(merge: true),
          );
    } else {
      throw Exception("Invalid jobAdId or job data");
    }
  }

  Future<void> saveNewJob(Map<String, dynamic> job) async {
    if (job.isNotEmpty) {
      job['numberOfApplicants'] = 0;

      try {
        await _db.collection("jobs").add(job);
      } catch (e) {
        throw Exception("Failed to save job: $e");
      }
    } else {
      throw Exception("Invalid job data");
    }
  }

  Future<void> updateJobAd(Map<String, dynamic> job,jobAdId) async {
    if (job.isNotEmpty) {
      await _db.collection("jobs").doc(jobAdId).set(
        job,
        SetOptions(merge: true),
      );
    } else {
      throw Exception("Invalid jobAdId or job data");
    }
  }

  Future<Job> getJobFromFirestore(String jobId) async {
    DocumentSnapshot jobAdDoc = await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();
    if (jobAdDoc.exists) {
      final jobAdData = jobAdDoc.data() as Map<String, dynamic>;
      Job job = Job.fromMap(jobAdData);
      return job;
    } else {
      throw Exception('Job not found or is deleted');
    }
  }
}
