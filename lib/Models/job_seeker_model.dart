class JobSeeker {
  String name;
  String email;
  String phone;
  String gender;
  String dob;
  String city;
  String profilePicUrl;
  String cvFileName;
  String resumeUrl;

  JobSeeker({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.city,
    required this.cvFileName,
    required this.resumeUrl,
    required this.profilePicUrl,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone':phone,
      'gender': gender,
      'dob': dob,
      'city': city,
      'resumeUrl': resumeUrl,
      'resumeFileName': cvFileName,
      'profilePicUrl': profilePicUrl,
    };
  }

  factory JobSeeker.fromMap(Map<String, dynamic> map) {
    return JobSeeker(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone:map['phone'] ??"",
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      city: map['city'] ?? '',
      cvFileName: map['resumeFileName'] ?? '',
      resumeUrl: map['resumeUrl'] ?? '',
      profilePicUrl: map['profilePicUrl'] ?? '',
    );
  }
}
// Future<void> saveJobSeeker(JobSeeker jobSeeker) async {
//   try {
//     await FirebaseFirestore.instance.collection('Users').doc(uid).set(jobSeeker.toMap(), SetOptions(merge: true));
//   } catch (e) {
//     print('Error saving job seeker data: $e');
//   }
// }
// Future<JobSeeker> fetchJobSeeker(String uid) async {
//   DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
//   if (snapshot.exists) {
//     return JobSeeker.fromMap(snapshot.data() as Map<String, dynamic>);
//   } else {
//     throw Exception("User not found");
//   }
// }