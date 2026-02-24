import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePictureWidget extends StatefulWidget {
  final File? imageFile;
  final Function(File) onImagePicked;

  const ProfilePictureWidget({
    super.key,
    required this.imageFile,
    required this.onImagePicked,
  });

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      widget.onImagePicked(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 60,
        backgroundImage: widget.imageFile != null
            ? FileImage(widget.imageFile!)
            : const NetworkImage('https://via.placeholder.com/150')
                as ImageProvider,
      ),
    );
  }
}