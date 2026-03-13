import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/home/services/home_services.dart';

part 'view_all_news_state.dart';

class ViewAllNewsCubit extends Cubit<ViewAllNewsState> {
  ViewAllNewsCubit() : super(ViewAllNewsInitial());

  final _homeServices = HomeServices();
  final _localDatabaseHive = LocalDatabaseHive();

  /// Load all breaking news (first 40 articles)
Future<void> loadBreakingNews() async {
  emit(ViewAllNewsLoading());

  try {
    final result = await _homeServices.getNews(page: 1, pageSize: 40);
    final articles = result.articles ?? [];

    // ✅ كل المقالات هنا breaking
    final breakingArticles = articles
        .map((a) => a.copyWith(isBreaking: true))
        .toList();

    emit(ViewAllNewsLoaded(breakingArticles));
  } catch (e) {
    emit(ViewAllNewsError(e.toString()));
  }
}
  // Future<void> loadBreakingNews() async {
  //   emit(ViewAllNewsLoading());

  //   try {
  //     final result = await _homeServices.getNews(page: 1, pageSize: 40);
  //     final articles = result.articles ?? [];

  //     emit(ViewAllNewsLoaded(articles));
  //   } catch (e) {
  //     emit(ViewAllNewsError(e.toString()));
  //   }
  // }

  /// Load all recommendation news (skip first 7 breaking, take the rest)
  Future<void> loadRecommendationNews() async {
    emit(ViewAllNewsLoading());

    try {
      final result = await _homeServices.getNews(page: 1, pageSize: 60);
      final allArticles = result.articles ?? [];
      final articles = allArticles.skip(7).toList();

      final favArticles = await _getFavorites();
      for (int i = 0; i < articles.length; i++) {
        var article = articles[i];
        final isFound =
            favArticles.any((element) => element.title == article.title);
        if (isFound) {
          article = article.copyWith(isFavorite: true);
          articles[i] = article;
        }
      }

      emit(ViewAllNewsLoaded(articles));
    } catch (e) {
      emit(ViewAllNewsError(e.toString()));
    }
  }

  Future<List<Article>> _getFavorites() async {
    final favorites = await _localDatabaseHive
        .getData<List<dynamic>?>(AppConstants.favoritesKey);
    if (favorites == null) return [];
    return favorites.map((e) => e as Article).toList();
  }
}
