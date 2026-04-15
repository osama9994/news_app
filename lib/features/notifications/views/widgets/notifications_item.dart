import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/features/notifications/notification_cubit/notification_cubit.dart';
import 'package:news_app/features/notifications/views/widgets/notification_image.dart';
class NotificationItem extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return ListTile(
      leading: NotificationImage(image: article.urlToImage),
      title: Text(
        article.title ?? tr.text('noTitle'),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        article.description ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          context.read<NotificationCubit>().deleteNotification(article);
        },
      ),
      onTap: onTap,
    );
  }
}

// class PlaceholderImage extends StatelessWidget {
//   const PlaceholderImage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         color: Colors.blue.withAlpha(25),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(
//         Icons.notifications_rounded,
//         color: Colors.blue,
//         size: 28,
//       ),
//     );
//   }
// }

// class NotificationImage extends StatelessWidget {
//   final String? image;

//   const NotificationImage({super.key, this.image});

//   @override
//   Widget build(BuildContext context) {
//     final hasImage = image != null && image!.isNotEmpty;

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: hasImage
//           ? Image.network(
//               image!,
//               width: 60,
//               height: 60,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => const PlaceholderImage(),
//             )
//           : const PlaceholderImage(),
//     );
//   }
// }