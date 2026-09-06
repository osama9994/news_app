import 'package:flutter/material.dart';
import 'package:news_app/core/localization/app_strings.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          Text(
            tr.text('noNotificationsYet'),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}