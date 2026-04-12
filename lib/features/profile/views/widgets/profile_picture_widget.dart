

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureWidget extends StatelessWidget {
  final File? imageFile;
  final Function(File) onImagePicked;

  const ProfilePictureWidget({
    super.key,
    required this.imageFile,
    required this.onImagePicked,
  });

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[300],
        backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
        child: imageFile == null
            ? const Icon(Icons.person, size: 60, color: Colors.white)
            : null,
      ),
    );
  }
}