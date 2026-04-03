import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/localization/language_cubit/language_state.dart';
import 'package:news_app/core/localization/language_storage.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState(AppLanguage.english)) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final language = await LanguageStorage.loadLanguage();
    if (language != state.language) {
      emit(LanguageState(language));
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (language == state.language) return;
    emit(LanguageState(language));
    await LanguageStorage.saveLanguage(language);
  }

  Future<void> toggleLanguage() async {
    await setLanguage(
      state.language == AppLanguage.english
          ? AppLanguage.arabic
          : AppLanguage.english,
    );
  }
}
