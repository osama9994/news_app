import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class AppTheme {
static ThemeData get mainTheme=> ThemeData(
        colorScheme: .fromSeed(seedColor: AppColors.primary),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
              fillColor: AppColors.grey2,
             
             border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
        ),
      );
      

}