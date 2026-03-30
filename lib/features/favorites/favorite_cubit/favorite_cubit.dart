import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_cubit.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_state.dart';
import 'favorite_state.dart';
import 'dart:async';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteActionsCubit actionsCubit;
  StreamSubscription? _subscription;

  FavoriteCubit(this.actionsCubit) : super(FavoriteLoading()) {

    // Emit current favorites even if empty
    emit(
      FavoriteLoaded(
        actionsCubit.favorites
            .map((a) => a.copyWith(isFavorite: true))
            .toList(),
      ),
    );

    _subscription = actionsCubit.stream.listen((state) {
      if (state is FavoriteActionsUpdated) {
        emit(
          FavoriteLoaded(
            state.favorites
                .map((a) => a.copyWith(isFavorite: true))
                .toList(),
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}