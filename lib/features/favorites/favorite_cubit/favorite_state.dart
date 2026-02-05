part of 'favorite_cubit.dart';


sealed class FavoriteState {
  const FavoriteState();
}

final class FavoriteInitial extends FavoriteState {}
final class FavoriteLoading extends FavoriteState {}
final class FavoriteLoaded extends FavoriteState {
 final List<Article>articles;

  FavoriteLoaded(this.articles);
}
final class FavoriteError extends FavoriteState {
 final String message;

  FavoriteError(this.message);
}

