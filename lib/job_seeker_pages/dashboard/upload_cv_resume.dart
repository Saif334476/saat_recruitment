import 'package:flutter/material.dart';

class UploadCvResume extends StatefulWidget {
  const UploadCvResume({super.key});

  @override
  State<UploadCvResume> createState() => _UploadCvResumeState();
}

class _UploadCvResumeState extends State<UploadCvResume> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(

            children: [
              const Text("You don't have Uploaded your CV/Resume yet,Please tap the icon below to continue application",style: TextStyle(color: Colors.red),),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.upload_file_outlined,
                    size: 100,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
