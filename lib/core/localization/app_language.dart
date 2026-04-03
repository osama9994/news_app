import 'package:flutter/material.dart';

enum AppLanguage {
  english(code: 'en'),
  arabic(code: 'ar');

  const AppLanguage({required this.code});

  final String code;

  Locale get locale => Locale(code);

  String get newsApiLanguage => code;

  String get homeQuery => this == AppLanguage.arabic ? 'أخبار' : 'news';

  String get fallbackSourceName =>
      this == AppLanguage.arabic ? 'مصدر غير معروف' : 'UNKNOWN';

  static AppLanguage fromCode(String? code) {
    return code == 'ar' ? AppLanguage.arabic : AppLanguage.english;
  }

  String apiCategoryQuery(String categoryKey) {
    switch (categoryKey.toLowerCase()) {
      case 'business':
        return this == AppLanguage.arabic ? 'أعمال' : 'business';
      case 'entertainment':
        return this == AppLanguage.arabic ? 'ترفيه' : 'entertainment';
      case 'health':
        return this == AppLanguage.arabic ? 'صحة' : 'health';
      case 'science':
        return this == AppLanguage.arabic ? 'علوم' : 'science';
      case 'sports':
        return this == AppLanguage.arabic ? 'رياضة' : 'sports';
      case 'technology':
        return this == AppLanguage.arabic ? 'تكنولوجيا' : 'technology';
      case 'politics':
        return this == AppLanguage.arabic ? 'سياسة' : 'politics';
      case 'general':
        return this == AppLanguage.arabic ? 'عام' : 'general';
      default:
        return categoryKey;
    }
  }
}
