import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/language_storage.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/article_translation_service.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/home/services/home_services.dart';

part 'view_all_news_state.dart';

class ViewAllNewsCubit extends Cubit<ViewAllNewsState> {
  ViewAllNewsCubit() : super(ViewAllNewsInitial());

  final _homeServices = HomeServices();
  final _localDatabaseHive = LocalDatabaseHive();

  List<Article> _rawArticles = [];
  bool _isBreakingMode = true;

  Future<void> loadBreakingNews() async {
    emit(ViewAllNewsLoading());
    _isBreakingMode = true;

    try {
      final result = await _homeServices.getNews(page: 1, pageSize: 40);
      _rawArticles = result.articles ?? [];
      await _emitFromRawArticles();
    } catch (e) {
      emit(ViewAllNewsError(e.toString()));
    }
  }

  Future<void> loadRecommendationNews() async {
    emit(ViewAllNewsLoading());
    _isBreakingMode = false;

    try {
      final result = await _homeServices.getNews(page: 1, pageSize: 60);
      _rawArticles = result.articles ?? [];
      await _emitFromRawArticles();
    } catch (e) {
      emit(ViewAllNewsError(e.toString()));
    }
  }

  Future<void> applyCurrentLanguage() async {
    if (_rawArticles.isEmpty) return;
    emit(ViewAllNewsLoading());
    try {
      await _emitFromRawArticles();
    } catch (e) {
      emit(ViewAllNewsError(e.toString()));
    }
  }

  Future<void> _emitFromRawArticles() async {
    final language = await LanguageStorage.loadLanguage();
    final translatedArticles = await ArticleTranslationService.instance
        .translateArticlesIfNeeded(_rawArticles, language);

    if (_isBreakingMode) {
      final breakingArticles =
          translatedArticles.map((a) => a.copyWith(isBreaking: true)).toList();
      emit(ViewAllNewsLoaded(breakingArticles));
      return;
    }

    final articles = translatedArticles.skip(7).toList();
    final favArticles = await _getFavorites();
    for (int i = 0; i < articles.length; i++) {
      var article = articles[i];
      final isFound =
          favArticles.any((element) => _isSameArticle(element, article));
      if (isFound) {
        article = article.copyWith(isFavorite: true);
        articles[i] = article;
      }
    }

    emit(ViewAllNewsLoaded(articles));
  }

  Future<List<Article>> _getFavorites() async {
    final favorites = await _localDatabaseHive
        .getData<List<dynamic>?>(AppConstants.favoritesKey);
    if (favorites == null) return [];
    return favorites.map((e) => e as Article).toList();
  }

  bool _isSameArticle(Article a, Article b) {
    final firstUrl = a.url?.trim();
    final secondUrl = b.url?.trim();
    if (firstUrl != null &&
        firstUrl.isNotEmpty &&
        secondUrl != null &&
        secondUrl.isNotEmpty) {
      return firstUrl == secondUrl;
    }
    return a.title == b.title;
  }
}
