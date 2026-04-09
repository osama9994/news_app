import 'package:news_app/core/models/article_model.dart';

sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoaded extends NotificationState {
  final List<Article> articles;

  NotificationLoaded(this.articles);
}
