import 'package:cloud_firestore/cloud_firestore.dart';

class JobProviderModel {
  String name;
  String location;
  String industry;
  String companySize;
  String email;
  String? documentUrl;
  JobProviderModel(
      {required this.location,required this.name,required this.industry, required this.companySize, required this.email});
  static Future<void> updateJpData(String? uid, Map<String, dynamic> field) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .update(field);
  }
  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'email': email,
      'Location': location,
      'Industry': industry,
      'companySize': companySize,
      'documentUrl':documentUrl
    };
  }

}
