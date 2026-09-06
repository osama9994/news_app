import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
import 'package:news_app/core/localization/app_language.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.language;
    final isArabic = language == AppLanguage.arabic;

    return TextButton(
  onPressed: () => context.read<LanguageCubit>().toggleLanguage(),
  style: TextButton.styleFrom(
    backgroundColor: Colors.grey.withValues(alpha: 0.15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
  ),
  child: Text(
    isArabic ? 'EN' : 'ع',
    style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
  ),

    );
  }
}