import 'package:cloud_firestore/cloud_firestore.dart';

class JobProviderModel {
  String id;
  String name;
  String location;
  String industry;
  String companySize;
  String email;
  String docUrl;

  JobProviderModel(
      {required this.location,
      required this.name,
      required this.industry,
      required this.companySize,
      required this.email,required this.docUrl,required this.id});


  static Future<void> updateJpData(
      String? uid, Map<String, dynamic> field) async {
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
      'legalDocUrl':docUrl
    };
  }
  factory JobProviderModel.fromMap(Map<String, dynamic> map) {
    return JobProviderModel(
      name: map['Name'],
      location: map['Location'],
      industry: map['Industry'] ,
      companySize: map['companySize'],
      email: map['Email'],
      docUrl: map['docUrl'], id: map['id'],
    );
  }
}
