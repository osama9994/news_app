import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/localization/language_storage.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/article_translation_service.dart';
import 'package:news_app/features/search/models/search_body.dart';
import 'package:news_app/features/search/services/search_services.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final searchServices = SearchServices();

  String? selectedCategory;
  List<Article> _rawArticles = [];

  static const List<String> categories = [
    'all',
    'sports',
    'technology',
    'politics',
    'business',
    'entertainment',
    'science',
    'health',
  ];

  void selectCategory(String category) {
    selectedCategory = category == 'all' ? null : category.toLowerCase();
    emit(CategorySelected(selectedCategory));
  }

  Future<void> search(String keyWord) async {
    if (keyWord.trim().isEmpty) return;

    emit(Searching());
    try {
      final language = await LanguageStorage.loadLanguage();
      final translatedKeyword = await ArticleTranslationService.instance
          .translateQueryToEnglish(keyWord, language);
      final query = selectedCategory != null
          ? '$translatedKeyword ${AppLanguage.english.apiCategoryQuery(selectedCategory!)}'
          : translatedKeyword;

      final body = SearchBody(
        q: query,
        language: 'en',
      );

      final response = await searchServices.search(body);
      _rawArticles = response.articles ?? [];
      await applyCurrentLanguage();
    } catch (e) {
      emit(SearchResultError(e.toString()));
    }
  }

  Future<void> applyCurrentLanguage() async {
    try {
      final language = await LanguageStorage.loadLanguage();
      final translatedArticles = await ArticleTranslationService.instance
          .translateArticlesIfNeeded(_rawArticles, language);
      emit(SearchResultsLoaded(translatedArticles));
    } catch (e) {
      emit(SearchResultError(e.toString()));
    }
  }
}
