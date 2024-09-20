class JobSeeker {
  String jsName;
  String jsEmail;
  String jsGender;
  String jsDob;
  String jsCity;
  String jsEducation;
  String jsExperience;
  String? jsCompanyName;
  String? jsSalary;
  String? jsExperienceDuration;
  String cvFileName;
  JobSeeker({
    required this.jsName,
    required this.jsEmail,
    required this.jsGender,
    required this.jsDob,
    required this.jsCity,
    required this.jsEducation,
    required this.jsExperience,
    required String? jsCompanyName,
    required String? jsSalary,
    required String? jsExperienceDuration,
    required this.cvFileName,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': jsName,
      'email': jsEmail,
      'gender': jsGender,
      'dob': jsDob,
      'city': jsCity,
      'education': jsEducation,
      'experrience': jsExperience,
      'companyName': jsCompanyName,
      'salary': jsSalary,
      'experienceDuration': jsExperienceDuration
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