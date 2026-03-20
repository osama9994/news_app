import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/features/favorites/services/favorites_services.dart';
import 'favorite_actions_state.dart';

class FavoriteActionsCubit extends Cubit<FavoriteActionsState> {
  FavoriteActionsCubit._internal() : super(FavoriteActionsInitial());
  static final FavoriteActionsCubit _instance = FavoriteActionsCubit._internal();
  factory FavoriteActionsCubit() => _instance;

  final FavoritesServices favoritesServices = FavoritesServices();
  List<Article> _favorites = [];

  // Expose a copy of the current favorites list (read-only for consumers)
  List<Article> get favorites => List<Article>.from(_favorites);

  bool _initialized = false;

  String _articleKey(Article a) {
    final title = a.title;
    if (title != null && title.isNotEmpty) return 'title:$title';
    final url = a.url;
    if (url != null && url.isNotEmpty) return 'url:$url';
    return 'fallback:${a.hashCode}';
  }

  List<Article> _mergeFavorites(List<Article> a, List<Article> b) {
    final map = <String, Article>{};
    for (final item in [...a, ...b]) {
      map[_articleKey(item)] = item;
    }
    return map.values.toList();
  }

  Future<void> initFavorites() async {
    // Ensure initialization logic runs only once
    if (_initialized) return;
    _initialized = true;

    final hiveFavorites = await favoritesServices.getFavoriteHive();
    _favorites = List<Article>.from(hiveFavorites);
    emit(FavoriteActionsUpdated(List<Article>.from(_favorites)));

    try {
      final firebaseFavorites = await favoritesServices.getFavoritesFromFirebase();

      // Avoid wiping local Hive favorites with an empty Firebase result
      // (common when Firebase/auth isn't ready during hot reload).
      if (firebaseFavorites.isNotEmpty) {
        _favorites = _mergeFavorites(hiveFavorites, firebaseFavorites);
        await favoritesServices.localDatabaseHive.saveData(
          'favorites',
          _favorites,
        );
        emit(FavoriteActionsUpdated(List<Article>.from(_favorites)));
      }
    } catch (_) {
      // If Firebase fails, keep Hive favorites so UI doesn't disappear.
    }
  }

  Future<void> setFavorite(Article article) async {
    emit(DoingFavoriteLoading(article.title ?? ""));
    try {
      final index = _favorites.indexWhere((e) => e.title == article.title);
      if (index != -1) {
        _favorites.removeAt(index);
        await favoritesServices.localDatabaseHive.saveData('favorites', _favorites);
        await favoritesServices.removeFavoriteFromFirebase(article);
      } else {
        _favorites.add(article);
        await favoritesServices.localDatabaseHive.saveData('favorites', _favorites);
        await favoritesServices.addFavoriteToFirebase(article);
      }
      emit(FavoriteActionsUpdated(List<Article>.from(_favorites)));
    } catch (e) {
      emit(DoingFavoriteError(e.toString(), article.title ?? ""));
    }
  }

  bool isFavorite(Article article) => _favorites.any((e) => e.title == article.title);
}
