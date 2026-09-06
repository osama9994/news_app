import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(ThemeMode.light)) {
    _loadSavedThemeMode();
  }

  final LocalDatabaseHive _localDatabaseHive = LocalDatabaseHive();

  Future<void> _loadSavedThemeMode() async {
    final saved = await _localDatabaseHive.getData<String?>(AppConstants.themeModeKey);
    final themeMode = _parseThemeMode(saved) ?? ThemeMode.light;
    if (themeMode != state.themeMode) {
      emit(ThemeState(themeMode));
    }
  }

  Future<void> toggleTheme() async {
    final next =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState(next));
    await _localDatabaseHive.saveData<String>(
      AppConstants.themeModeKey,
      _serializeThemeMode(next),
    );
  }

  ThemeMode? _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }

  String _serializeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
