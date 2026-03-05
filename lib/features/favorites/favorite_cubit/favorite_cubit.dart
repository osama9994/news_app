import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_cubit.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_state.dart';

import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteActionsCubit favoriteActionsCubit = FavoriteActionsCubit();

  FavoriteCubit() : super(FavoriteLoading()) {
    // If favorites were already initialized globally, sync them immediately
    final initialFavorites = favoriteActionsCubit.favorites;
    if (initialFavorites.isNotEmpty) {
      emit(
        FavoriteLoaded(
          initialFavorites
              .map((article) => article.copyWith(isFavorite: true))
              .toList(),
        ),
      );
    }

    // Listen to any favorites updates (add/remove) and update the UI list
    favoriteActionsCubit.stream.listen((state) {
      if (state is FavoriteActionsUpdated) {
        emit(
          FavoriteLoaded(
            state.favorites
                .map((article) => article.copyWith(isFavorite: true))
                .toList(),
          ),
        );
      }
    });
  }
}



