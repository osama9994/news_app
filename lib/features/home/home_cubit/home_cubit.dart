import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/home/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final homeServices = HomeServices();
  final localDatabaseHive = LocalDatabaseHive();

  List<Article> _rawHomeArticles = [];

  Future<void> getHomeNews() async {
    emit(HomeLoading());

    try {
      final result = await homeServices.getNews(page: 1, pageSize: 25);
      _rawHomeArticles = result.articles ?? [];
      await _emitFromRawArticles();
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> applyCurrentLanguage() async {
    if (_rawHomeArticles.isEmpty) return;
    emit(HomeLoading());
    try {
      await _emitFromRawArticles();
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _emitFromRawArticles() async {
    final articles = List<Article>.from(_rawHomeArticles);

    final breakingNews =
        articles.take(7).map((a) => a.copyWith(isBreaking: true)).toList();
    final recommendationNews = articles
        .skip(7)
        .take(15)
        .map((a) => a.copyWith(isBreaking: false))
        .toList();

    final favArticles = await _getFavorites();
    for (int i = 0; i < recommendationNews.length; i++) {
      var article = recommendationNews[i];
      final isFound =
          favArticles.any((element) => _isSameArticle(element, article));
      if (isFound) {
        article = article.copyWith(isFavorite: true);
        recommendationNews[i] = article;
      }
    }

    emit(HomeLoaded(
      breakingNews: breakingNews,
      recommendationNews: recommendationNews,
    ));
  }

  Future<List<Article>> _getFavorites() async {
    final favorites =
        await localDatabaseHive.getData<List<dynamic>?>(AppConstants.favoritesKey);
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
