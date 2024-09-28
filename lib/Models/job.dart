import 'package:cloud_firestore/cloud_firestore.dart';
import 'mcq_model.dart';

class Job {
  final String jobId;
  final String jobTitle;
  final String selectedCategory;
  final String jobType;
  final String requiredExperience;
  final String location;
  final String salary;
  final String selectedOption;
  final List<MCQ> mcq;
  final String postedBy;
  final DateTime postedAt;

  Job({
    required this.jobId,
    required this.jobTitle,
    required this.selectedCategory,
    required this.jobType,
    required this.requiredExperience,
    required this.location,
    required this.salary,
    required this.selectedOption,
    required this.mcq,
    required this.postedBy,
    required this.postedAt,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      jobId: map['jobId'],
      jobTitle: map['jobTitle'],
      selectedCategory: map['selectedCategory'],
      jobType: map['jobType'],
      requiredExperience: map['requiredExperience'],
      location: map['location'],
      salary: map['salary'],
      selectedOption: map['selectedOption'],
      mcq: (map['mcq'] as List).map((mcq) => MCQ.fromMap(mcq)).toList(),
      postedBy: map['postedBy'],
      postedAt: (map['postedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'jobTitle': jobTitle,
      'selectedCategory': selectedCategory,
      'jobType': jobType,
      'requiredExperience': requiredExperience,
      'location': location,
      'salary': salary,
      'selectedOption': selectedOption,
      'mcq': mcq.map((mcq) => mcq.toMap()).toList(),
      'postedBy': postedBy,
      'postedAt': Timestamp.fromDate(postedAt),
    };
  }
}
