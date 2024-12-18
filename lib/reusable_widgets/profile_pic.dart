import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePicWidget extends StatefulWidget {
  final Function(File) onImagePicked;
  final String uploadedProfileUrl;

  const ProfilePicWidget({
    super.key,
    required this.onImagePicked,
    required this.uploadedProfileUrl,
  });

  @override
  ProfilePicWidgetState createState() => ProfilePicWidgetState();
}

class ProfilePicWidgetState extends State<ProfilePicWidget> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onImagePicked(_imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(100),
            ),
            height: 130,
            width: 130,
            child: ClipOval(
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.fill,
                    )
                  : widget.uploadedProfileUrl.isNotEmpty
                      ? Image.network(
                          widget.uploadedProfileUrl,
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                        )
                      : Image.asset(
                          "assets/person.webp",
                          fit: BoxFit.fill,
                        ),
            ),
          ),
        ),
        Positioned(
          left: 105,
          top: 18,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xff1C4374),
            ),
            child: IconButton(
              onPressed: _pickImage,
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
