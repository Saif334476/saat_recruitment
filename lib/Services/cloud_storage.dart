import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FileUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadProfilePic(File file, String uid) async {
    try {
      final storageRef = _storage.ref().child('SAAT/profile_pics/$uid.jpg');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload profile picture: $e");
    }
  }
  Future<String> uploadResume(File file, String uid) async {
    try {
      final storageRef = _storage.ref().child('SAAT/resumes/$uid.pdf');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload resume: $e");
    }
  }
  Future<String> uploadDocument(File file, String uid) async {
    try {
      final storageRef = _storage.ref().child('SAAT/Legal Docs/$uid.pdf');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload resume: $e");
    }
  }


}




















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'job.dart';
// import 'mcq_model.dart';
//
// class JobService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Create a new job
//   Future<void> createJob(Job job) async {
//     final uid = _auth.currentUser!.uid;
//     await _firestore
//         .collection('users')
//         .doc(uid)
//         .collection('Job Ads')
//         .doc(DateTime.now.toString()).set(job.toJson());
//   }
//
//   // Get all jobs for the current user
//   Stream<QuerySnapshot> getJobs() {
//     final uid = _auth.currentUser!.uid;
//     return _firestore
//         .collection('users')
//         .doc(uid)
//         .collection('Job Ads')
//         .snapshots();
//   }
//
//   // Update a job
//   Future<void> updateJob(Job job) async {
//     final uid = _auth.currentUser!.uid;
//     final dateTime = DateTime.now();
//     await _firestore
//         .collection('users')
//         .doc(uid)
//         .collection('Job Ads')
//         .doc((dateTime.toString()))
//         .set(job.toJson());
//   }
//
//   // Delete a job
//   Future<void> deleteJob(String jobId) async {
//     final uid = _auth.currentUser!.uid;
//     await _firestore
//         .collection('users')
//         .doc(uid)
//         .collection('Job Ads')
//         .doc(jobId)
//         .delete();
//   }
//
//   // Create a new MCQ for a job
//   Future<void> createMCQ(String jobId, MCQ mcq) async {
//     final uid = _auth.currentUser!.uid;
//     await _firestore
//         .collection('users')
//         .doc(uid)
//         .collection('jobs')
//         .doc(jobId)
//         .collection('mcqs')
//         .add(mcq.toJson());
//   }
//
//   // Get all MCQs for a job
//   Stream<QuerySnapshot> getMCQs(String jobId) {
//     final uid = _auth.currentUser!.uid;
//     return _firestore
//         .collection('users')
//         .doc(uid)
//         .collection('jobs')
//         .doc(jobId)
//         .collection('mcqs')
//         .snapshots();
//   }
// }
