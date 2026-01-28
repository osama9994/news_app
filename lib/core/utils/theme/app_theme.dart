import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class AppTheme {
static ThemeData get mainTheme=> ThemeData(
        colorScheme: .fromSeed(seedColor: AppColors.primary),
      );

}