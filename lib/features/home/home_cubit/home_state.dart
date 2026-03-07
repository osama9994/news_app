// part of 'home_cubit.dart';

// sealed class HomeState {
//   const HomeState();
// }

// final class HomeInitial extends HomeState {}
// //Top headlines
// final class TopHeadlinesLoading extends HomeState {}
// final class TopHeadlinesLoaded extends HomeState {
//   final List<Article>? articles;

//   TopHeadlinesLoaded(this.articles);
// }
// final class TopHeadlinesError extends HomeState {
//   final String message;
//   const TopHeadlinesError(this.message);
// }

// //Recommended
// final class RecommendedNewsLoading extends HomeState {}
// final class RecommendedNewsLoaded extends HomeState {
//   final List<Article>? articles;

//   RecommendedNewsLoaded(this.articles);
// }
// final class RecommendedNewsError extends HomeState {
//   final String message;
//   RecommendedNewsError(this.message);
// }

part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<Article> breakingNews;
  final List<Article> recommendationNews;

  HomeLoaded({
    required this.breakingNews,
    required this.recommendationNews,
  });
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}