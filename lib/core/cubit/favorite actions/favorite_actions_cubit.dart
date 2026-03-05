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

  Future<void> initFavorites() async {
    // Ensure initialization logic runs only once
    if (_initialized) return;
    _initialized = true;

    _favorites = await favoritesServices.getFavoriteHive();
    emit(FavoriteActionsUpdated(List<Article>.from(_favorites)));

    final firebaseFavorites = await favoritesServices.getFavoritesFromFirebase();
    _favorites = firebaseFavorites;
    await favoritesServices.localDatabaseHive.saveData('favorites', _favorites);
    emit(FavoriteActionsUpdated(List<Article>.from(_favorites)));
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
