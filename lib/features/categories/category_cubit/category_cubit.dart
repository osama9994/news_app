
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/categories/category_cubit/category_state.dart';
import 'package:news_app/features/categories/services/category_services_retrofit.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final Dio dio = Dio();

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