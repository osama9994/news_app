// 

import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}