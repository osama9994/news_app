import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final LocalDatabaseHive _database = LocalDatabaseHive();

  Future<void> loadNotifications() async {
    final data =
        await _database.getData<List<dynamic>?>(AppConstants.notificationsKey);

    if (data == null) {
      emit(NotificationLoaded([]));
      return;
    }

    final articles = data.map((e) => e as Article).toList();

    emit(NotificationLoaded(articles));
  }

  Future<void> addNotification(Article article) async {
    final data =
        await _database.getData<List<dynamic>?>(AppConstants.notificationsKey);

    List<Article> articles = [];

    if (data != null) {
      articles = data.map((e) => e as Article).toList();
    }

    articles.insert(0, article);

    await _database.saveData(AppConstants.notificationsKey, articles);

    emit(NotificationLoaded(articles));
  }

  Future<void> deleteNotification(Article article) async {
    final data =
        await _database.getData<List<dynamic>?>(AppConstants.notificationsKey);

    if (data == null) return;

    List<Article> articles = data.map((e) => e as Article).toList();

    articles.removeWhere((e) => e.title == article.title);

    await _database.saveData(AppConstants.notificationsKey, articles);

    emit(NotificationLoaded(articles));
  }
}