import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/categories/views/widgets/interests_shimmer.dart';
import 'package:news_app/features/home/views/pages/article_details_page.dart';
import 'package:news_app/features/notifications/notification_cubit/notification_cubit.dart';
import 'package:news_app/features/notifications/notification_cubit/notification_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoaded) {
            if (state.articles.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined,
                        size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text("No Notifications yet",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                final hasImage = article.urlToImage != null &&
                    article.urlToImage!.isNotEmpty;

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: hasImage
                        ? Image.network(
                            article.urlToImage!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            // ✅ عرض placeholder إذا فشل التحميل
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        // ✅ عرض placeholder إذا لم تكن هناك صورة
                        : _placeholder(),
                  ),
                  title: Text(
                    article.title ?? "No title",
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
                    tooltip: "Delete notification",
                    onPressed: () {
                      context
                          .read<NotificationCubit>()
                          .deleteNotification(article);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailsPage(article: article),
                      ),
                    );
                  },
                );
              },
            );
          }

          return InterestsShimmer();
        },
      ),
    );
  }

  // ✅ Placeholder widget
  Widget _placeholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.notifications_rounded,
          color: Colors.blue, size: 28),
    );
  }
}