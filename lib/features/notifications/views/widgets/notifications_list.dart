import 'package:flutter/material.dart';
import 'package:news_app/features/notifications/views/widgets/notifications_item.dart';

class NotificationsList extends StatelessWidget {
  final List articles;

  const NotificationsList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return NotificationItem(article: articles[index]);
      },
    );
  }
}