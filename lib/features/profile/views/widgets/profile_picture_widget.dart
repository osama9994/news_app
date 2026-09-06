// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfilePictureWidget extends StatelessWidget {
//   final File? imageFile;
//   final String? networkImageUrl; // الآن هذا base64 string
//   final Function(File) onImagePicked;

//   const ProfilePictureWidget({
//     super.key,
//     required this.imageFile,
//     required this.onImagePicked,
//     this.networkImageUrl,
//   });

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       onImagePicked(File(pickedFile.path));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ImageProvider? imageProvider;

//     if (imageFile != null) {
//       imageProvider = FileImage(imageFile!);
//     } else if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
//       // تحويل Base64 إلى صورة
//       imageProvider = MemoryImage(base64Decode(networkImageUrl!));
//     }

//     return GestureDetector(
//       onTap: _pickImage,
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.grey[300],
//             backgroundImage: imageProvider,
//             child: imageProvider == null
//                 ? const Icon(Icons.person, size: 60, color: Colors.white)
//                 : null,
//           ),
//           Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.edit, size: 16, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureWidget extends StatelessWidget {
  final File? imageFile;         // صورة مؤقتة أثناء الرفع
  final Object? photoData;       // Uint8List (Hive) أو String (URL)
  final Function(File) onImagePicked;

  const ProfilePictureWidget({
    super.key,
    required this.onImagePicked,
    this.imageFile,
    this.photoData,
  });

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 400,
      maxHeight: 400,
    );
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  Widget _buildAvatar(BuildContext context) {
    // الأولوية 1: صورة جديدة اختارها المستخدم للتو (ملف مؤقت)
    if (imageFile != null) {
      return _circle(FileImage(imageFile!));
    }

    // الأولوية 2: bytes من Hive — فوري بدون إنترنت
    if (photoData is Uint8List) {
      return _circle(MemoryImage(photoData as Uint8List));
    }

    // الأولوية 3: رابط URL — مع كاش تلقائي
    if (photoData is String && (photoData as String).isNotEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: photoData as String,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            placeholder: (_, __) => _defaultIcon(),
            errorWidget: (_, __, ___) => _defaultIcon(),
          ),
        ),
      );
    }

    // الأولوية 4: لا توجد صورة
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.grey[300],
      child: _defaultIcon(),
    );
  }

  Widget _circle(ImageProvider provider) => CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[300],
        backgroundImage: provider,
      );

  Widget _defaultIcon() =>
      const Icon(Icons.person, size: 60, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildAvatar(context),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}