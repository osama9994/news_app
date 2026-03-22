// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app/core/models/article_model.dart';
// import 'package:news_app/core/utils/app_constants.dart';
// import 'package:news_app/features/search/models/search_body.dart';
// import 'package:news_app/features/search/services/search_services.dart';
// import 'package:news_app/features/search/services/search_services_retrofit.dart';

// part 'search_state.dart';

// class SearchCubit extends Cubit<SearchState> {
//   SearchCubit() : super(SearchInitial());
//   final searchServices = SearchServices();
//   final searchServicesRetrofit = SearchServicesRetrofit(
//     Dio(),
//     //baseUrl: AppConstants.baseUrl
//   );
//   Future<void> search(String keyWord) async {
//     emit(Searching());
//     try {
//       final body = SearchBody(q: keyWord);
//       final response = await searchServicesRetrofit.search(
//         body.q,
//         body.page,
//         body.pageSize,
//         body.searchIn,
//         "Bearer ${AppConstants.apiKey}",
//       );
//       emit(SearchResultsLoaded(response.articles ?? []));
//     } catch (e) {
//       emit(SearchResultError(e.toString()));
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/search/models/search_body.dart';
import 'package:news_app/features/search/services/search_services.dart';
import 'package:news_app/features/search/services/search_services_retrofit.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final searchServices = SearchServices();
  final searchServicesRetrofit = SearchServicesRetrofit(Dio());

  // ✅ الفئة المختارة حالياً
  String? selectedCategory;

  // ✅ الفئات المتاحة
  static const List<String> categories = [
    'All',
    'Sports',
    'Technology',
    'Politics',
    'Business',
    'Entertainment',
    'Science',
    'Health',
  ];

  // ✅ تغيير الفئة
  void selectCategory(String category) {
    selectedCategory = category == 'All' ? null : category.toLowerCase();
    emit(CategorySelected(selectedCategory));
  }

  // ✅ البحث مع الفئة
  Future<void> search(String keyWord) async {
    // ✅ لا تبحث إذا النص فارغ
    if (keyWord.trim().isEmpty) return;

    emit(Searching());
    try {
      // ✅ إذا في فئة مختارة نضيفها للبحث
      final query = selectedCategory != null
          ? '$keyWord $selectedCategory'
          : keyWord;

      final body = SearchBody(q: query);
      final response = await searchServicesRetrofit.search(
        body.q,
        body.page,
        body.pageSize,
        body.searchIn,
        "Bearer ${AppConstants.apiKey}",
      );
      emit(SearchResultsLoaded(response.articles ?? []));
    } catch (e) {
      emit(SearchResultError(e.toString()));
    }
  }
}