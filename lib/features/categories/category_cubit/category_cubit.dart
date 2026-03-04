import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/categories/category_cubit/category_state.dart';
import 'package:news_app/features/categories/services/category_services_retrofit.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final dio = Dio();

  Future<void> getCategoryNews(String category) async {
    try {
      emit(CategoryLoading());

      final service = CategoryServicesRetrofit(dio);

      final response = await service.getCategoryNews(
        "us",
        category,
        AppConstants.apiKey,
      );

      emit(CategoryLoaded(response.articles ?? []));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}

// import 'dart:convert';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:news_app/core/models/news_api_response.dart';
// import 'package:news_app/core/utils/app_constants.dart';
// import 'package:news_app/features/categories/category_cubit/category_state.dart';

// class CategoryCubit extends Cubit<CategoryState> {
//   CategoryCubit() : super(CategoryInitial());

//   final dio = Dio();

//   Future<void> getCategoryNews(String category) async {
//     try {
//       emit(CategoryLoading());

//       final response = await dio.get(
//         "https://api.allorigins.win/raw",
//         queryParameters: {
//           "url":
//               "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=${AppConstants.apiKey}"
//         },
//       );

//       // 👇 مهم جدًا لـ Web
//       final decodedData = response.data is String
//           ? jsonDecode(response.data)
//           : response.data;

//       final news = NewsApiResponse.fromJson(decodedData);

//       emit(CategoryLoaded(news.articles ?? []));
//     } catch (e) {
//       emit(CategoryError(e.toString()));
//     }
//   }
// }