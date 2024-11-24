class JobSeeker {
  String jsName;
  String jsEmail;
  String jsGender;
  String jsDob;
  String jsCity;
  String cvFileName;
  String resumeUrl;
  JobSeeker({
    required this.jsName,
    required this.jsEmail,
    required this.jsGender,
    required this.jsDob,
    required this.jsCity,
    required this.cvFileName,
    required this.resumeUrl
  });
  Map<String, dynamic> toMap() {
    return {
      'name': jsName,
      'email': jsEmail,
      'gender': jsGender,
      'dob': jsDob,
      'city': jsCity,
      'resumeUrl': resumeUrl
    };
  }
}
// List<JobSeeker> jobSeeker = [
//   JobSeeker(
//       jsName: "jsName",
//       jsEmail: "saif34476@gmail.com",
//       jsGender: "Male",
//       jsDob: "26-11-2001",
//       jsCity: "Jhang",
//       jsEducation: "Graduated",
//       jsExperience: "No",
//       jsCompanyName: "Null",
//       jsSalary: "50000",
//       jsExperienceDuration: "null",
//       cvFileName: "fox.pdf")
// ];
