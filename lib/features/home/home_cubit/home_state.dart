
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