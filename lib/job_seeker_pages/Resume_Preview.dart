import 'dart:io';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart';

class ResumePreview extends StatefulWidget {
  final File selectedFile;
  final String selectedFileName;
  const ResumePreview(
      {super.key, required this.selectedFile, required this.selectedFileName});

  @override
  State<ResumePreview> createState() => _ResumePreviewState();
}

Widget getFilePreview(File file, String selectedFileName) {
  String fileExtension = extension(selectedFileName).toLowerCase().replaceAll('.', '');

  if (fileExtension == 'pdf') {
    return SfPdfViewer.file(file);
  } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension)) {
    try {
      return Image.file(file);
    } catch (e) {
      return Text(
        'Error loading image: $e',
        style: const TextStyle(fontSize: 18),
      );
    }
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

class _ResumePreviewState extends State<ResumePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Resume Preview"),
        ),
        body: Flexible(
          child: Column(
            children: [
              Expanded(
                child: getFilePreview(widget.selectedFile, widget.selectedFileName),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: cupertinoButtonWidget("OK", () {
                  Navigator.pop(context);
                }),
              )
            ],
          ),
        ));
  }
}