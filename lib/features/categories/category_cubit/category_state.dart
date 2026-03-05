import 'package:news_app/core/models/article_model.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Article> articles;

  CategoryLoaded(this.articles);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}