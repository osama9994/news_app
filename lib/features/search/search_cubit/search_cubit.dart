import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/language_storage.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/features/search/models/search_body.dart';
import 'package:news_app/features/search/services/search_services.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final searchServices = SearchServices();

  String? selectedCategory;

  static const List<String> categories = [
    'all',
    'sports',
    'technology',
    'politics',
    'business',
    'entertainment',
    'science',
    'health',
  ];

  void selectCategory(String category) {
    selectedCategory = category == 'all' ? null : category.toLowerCase();
    emit(CategorySelected(selectedCategory));
  }

  Future<void> search(String keyWord) async {
    if (keyWord.trim().isEmpty) return;

    emit(Searching());
    try {
      final language = await LanguageStorage.loadLanguage();
      final query = selectedCategory != null
          ? '$keyWord ${language.apiCategoryQuery(selectedCategory!)}'
          : keyWord;

      final body = SearchBody(
        q: query,
        language: language.newsApiLanguage,
      );

      final response = await searchServices.search(body);
      emit(SearchResultsLoaded(response.articles ?? []));
    } catch (e) {
      emit(SearchResultError(e.toString()));
    }
  }
}
