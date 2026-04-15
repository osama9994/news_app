import 'package:flutter/material.dart';
import 'package:news_app/features/notifications/views/widgets/placeholder_image.dart';
class NotificationImage extends StatelessWidget {
  final String? image;

  const NotificationImage({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    final hasImage = image != null && image!.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: hasImage
          ? Image.network(
              image!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const PlaceholderImage(),
            )
          : const PlaceholderImage(),
    );
  }
}