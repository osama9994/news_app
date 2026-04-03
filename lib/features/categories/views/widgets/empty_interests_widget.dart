import 'package:flutter/material.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class EmptyInterestsWidget extends StatelessWidget {
  const EmptyInterestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.interests_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            tr.text('emptyInterestsTitle'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr.text('emptyInterestsSubtitle'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.profileRoute),
            icon: const Icon(Icons.edit),
            label: Text(tr.text('editInterests')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
