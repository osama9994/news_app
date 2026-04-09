// import 'package:flutter/material.dart';
// import 'package:news_app/core/utils/theme/app_colors.dart';

// class AppTheme {
// static ThemeData get mainTheme=> ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
//         inputDecorationTheme: InputDecorationTheme(
//             filled: true,
//               fillColor: AppColors.grey2,
             
//              border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//         ),
//       );
      

// }

import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class AppTheme {
  // --- الوضع الفاتح ---
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: _buildInputDecorationTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      );

  // --- الوضع المظلم ---
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color(0xFF121212), // أسود مريح للعين
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: _buildInputDecorationTheme(isDark: true),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      );

  static InputDecorationTheme _buildInputDecorationTheme({bool isDark = false}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2C) : AppColors.grey2,
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
    );
  }
}
