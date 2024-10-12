import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewDoc extends StatefulWidget {
  final String url;
  final String id;
  const PreviewDoc({required this.url,required this.id,super.key,});

  @override
  State<PreviewDoc> createState() => _PreviewDocState();
}

class _PreviewDocState extends State<PreviewDoc> {

  void updateStatus(){
    FirebaseFirestore.instance.collection('Users').doc(widget.id).update({"isActive":true});
  }

  Widget _getFilePreview(String fileUrl) {
    Uri parsedUrl = Uri.parse(fileUrl);
    String fileExtension = parsedUrl.path.split('.').last.toLowerCase();

    if (fileExtension == 'pdf') {
      return const Text('PDF Preview not supported');
    } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension)) {
      return Image.network(fileUrl);
    } else if (['doc', 'docx'].contains(fileExtension)) {
      return const Text(
        'Microsoft Word Document',
        style: TextStyle(fontSize: 18),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      return const Text(
        'Microsoft Excel Spreadsheet',
        style: TextStyle(fontSize: 18),
      );
    } else {
      return const Text(
        'Unsupported file type',
        style: TextStyle(fontSize: 18),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C4374),
        automaticallyImplyLeading: false,
        title: const Text(
          "Document",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child:_getFilePreview(widget.url),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(right: 10.0,left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                      color: const Color(0xff1C4374),
                      child: const Text(
                        "Back",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      onPressed: () {Navigator.pop(context);}),
                  CupertinoButton(
                    color: const Color(0xff1C4374),
                      child: const Text(
                        "Validate",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      onPressed: () {updateStatus();}),
                ],
              ),
            ),const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
