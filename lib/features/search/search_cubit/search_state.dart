// part of 'search_cubit.dart';


// sealed class SearchState {
//   const SearchState();
// }

// final class SearchInitial extends SearchState {}

// final class Searching extends SearchState {}
// final class SearchResultsLoaded extends SearchState {
//   final List<Article>articles;

// const  SearchResultsLoaded( this.articles);
// }
// final class SearchResultError extends SearchState{

//   final String message;

//   SearchResultError( this.message);
// }

part of 'search_cubit.dart';

sealed class SearchState {
  const SearchState();
}

final class SearchInitial extends SearchState {}

final class Searching extends SearchState {}

final class SearchResultsLoaded extends SearchState {
  final List<Article> articles;
  const SearchResultsLoaded(this.articles);
}

final class SearchResultError extends SearchState {
  final String message;
  SearchResultError(this.message);
}

// ✅ جديد - عند تغيير الفئة
final class CategorySelected extends SearchState {
  final String? category;
  const CategorySelected(this.category);
}