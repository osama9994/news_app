part of 'favorite_actions_cubit.dart';


// sealed class FavoriteActionsState {
//   const FavoriteActionsState(); 
// } 

// final class FavoriteActionsInitial extends FavoriteActionsState {}

//  //Favorites
// final class DoingFavoriteLoading extends FavoriteActionsState {
//    final String title;

//   DoingFavoriteLoading(this.title);
// }
// final class FavoriteAdded extends FavoriteActionsState {
//   final String title;

//   FavoriteAdded( this.title);
  
// }
// final class FavoriteRemoved extends FavoriteActionsState {
//   final String title;

//   FavoriteRemoved(this.title);
// }
// final class DoingFavoriteError extends FavoriteActionsState {
//   final String message;
//    final String title;
//   DoingFavoriteError(this.message,  this.title);
// }

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