import 'package:news_app/core/models/article_model.dart';





sealed class FavoriteActionsState {
  const FavoriteActionsState();
}

final class FavoriteActionsInitial extends FavoriteActionsState {}

final class FavoriteActionsUpdated extends FavoriteActionsState {
  final List<Article> favorites;
  const FavoriteActionsUpdated(this.favorites);
}

final class DoingFavoriteLoading extends FavoriteActionsState {
  final String title;
  const DoingFavoriteLoading(this.title);
}

final class DoingFavoriteError extends FavoriteActionsState {
  final String error;
  final String title;
  const DoingFavoriteError(this.error, this.title);
}
// JUST WITH HIVE
// sealed class FavoriteActionsState {
//   const FavoriteActionsState();
// }

// final class FavoriteActionsInitial extends FavoriteActionsState {}

// final class FavoriteActionsUpdated extends FavoriteActionsState {
//   final List<Article> favorites;
//   const FavoriteActionsUpdated(this.favorites);
// }

// final class DoingFavoriteLoading extends FavoriteActionsState {
//   final String title;
//   const DoingFavoriteLoading(this.title);
// }

// final class DoingFavoriteError extends FavoriteActionsState {
//   final String error;
//   final String title;
//   const DoingFavoriteError(this.error, this.title);
// }