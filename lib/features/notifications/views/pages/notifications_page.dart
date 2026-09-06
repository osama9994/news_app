import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/features/categories/views/widgets/interests_shimmer.dart';
import 'package:news_app/features/notifications/notification_cubit/notification_cubit.dart';
import 'package:news_app/features/notifications/notification_cubit/notification_state.dart';
import 'package:news_app/features/notifications/views/widgets/empty_notifications.dart';
import 'package:news_app/features/notifications/views/widgets/notifications_list.dart';

// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final tr = context.tr;

//     return Scaffold(
//       appBar: AppBar(title: Text(tr.text('notifications'))),
//       body: BlocBuilder<NotificationCubit, NotificationState>(
//         builder: (context, state) {
//           if (state is NotificationLoaded) {
//             if (state.articles.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.notifications_off_outlined,
//                       size: 64,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       tr.text('noNotificationsYet'),
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return ListView.builder(
//               itemCount: state.articles.length,
//               itemBuilder: (context, index) {
//                 final article = state.articles[index];
//                 final hasImage = article.urlToImage != null &&
//                     article.urlToImage!.isNotEmpty;

//                 return ListTile(
//                   leading: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: hasImage
//                         ? Image.network(
//                             article.urlToImage!,
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => _placeholder(),
//                           )
//                         : _placeholder(),
//                   ),
//                   title: Text(
//                     article.title ?? tr.text('noTitle'),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   subtitle: Text(
//                     article.description ?? "",
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete_outline),
//                     tooltip: tr.text('deleteNotification'),
//                     onPressed: () {
//                       context
//                           .read<NotificationCubit>()
//                           .deleteNotification(article);
//                     },
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ArticleDetailsPage(article: article),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }

//           return InterestsShimmer();
//         },
//       ),
//     );
//   }

//   Widget _placeholder() {
//     return Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         color: Colors.blue.withAlpha(25),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(Icons.notifications_rounded, color: Colors.blue, size: 28),
//     );
//   }
// }


class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(tr.text('notifications'))),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoaded) {
            if (state.articles.isEmpty) {
              return const EmptyNotifications();
            }

            return NotificationsList(articles: state.articles);
          }

          return const InterestsShimmer();
        },
      ),
    );
  }
}