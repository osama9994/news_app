part of 'view_all_news_cubit.dart';

sealed class ViewAllNewsState {
  const ViewAllNewsState();
}

final class ViewAllNewsInitial extends ViewAllNewsState {}

final class ViewAllNewsLoading extends ViewAllNewsState {}

final class ViewAllNewsLoaded extends ViewAllNewsState {
  final List<Article> articles;

  ViewAllNewsLoaded(this.articles);
}

final class ViewAllNewsError extends ViewAllNewsState {
  final String message;
  ViewAllNewsError(this.message);
}
