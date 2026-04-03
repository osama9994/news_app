import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';

class LanguageStorage {
  LanguageStorage._();

  static final LocalDatabaseHive _localDatabaseHive = LocalDatabaseHive();

  static Future<AppLanguage> loadLanguage() async {
    final savedCode =
        await _localDatabaseHive.getData<String?>(AppConstants.languageKey);
    return AppLanguage.fromCode(savedCode);
  }

  static Future<void> saveLanguage(AppLanguage language) async {
    await _localDatabaseHive.saveData<String>(
      AppConstants.languageKey,
      language.code,
    );
  }
}
