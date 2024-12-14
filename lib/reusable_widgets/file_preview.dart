import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FilePreview extends StatelessWidget {
  const FilePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Widget getFilePreview(String? fileUrl, isUrl, File? file) {
  String fileExtension = "";
  if (file != null) {
    Uri parsedUrl = Uri.parse(file.path);
    fileExtension = parsedUrl.path.split('.').last.toLowerCase();
  }
  if (isUrl && fileUrl!= null) {
    return SfPdfViewer.network(fileUrl);
  } else if (fileExtension == 'pdf') {
    return SfPdfViewer.file(file!);
  } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension)) {
     return Image.file(file!);
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
