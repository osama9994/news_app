// import 'package:dio/dio.dart';
// import 'package:news_app/core/models/news_api_response.dart';
// import 'package:news_app/core/utils/app_constants.dart';
// import 'package:retrofit/retrofit.dart';
// part 'category_services_retrofit.g.dart';


// @RestApi(baseUrl: AppConstants.baseUrl)
// abstract class CategoryServicesRetrofit {
//   factory CategoryServicesRetrofit(Dio dio, {String? baseUrl}) =
//       _CategoryServicesRetrofit;

//   // Use the correct NewsAPI endpoint (v2/top-headlines)
//   @GET(AppConstants.topHeadLines)
//   Future<NewsApiResponse> getCategoryNews(
//     @Query('country') String country,
//     @Query('category') String category,
//     @Query('apiKey') String apiKey,
//   );
// }

import 'package:dio/dio.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:retrofit/retrofit.dart';
part 'category_services_retrofit.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class CategoryServicesRetrofit {
  factory CategoryServicesRetrofit(Dio dio, {String? baseUrl}) =
      _CategoryServicesRetrofit;

  @GET(AppConstants.topHeadLines)
  Future<NewsApiResponse> getCategoryNews(
    @Query('country') String country,
    @Query('category') String category,
    @Query('apiKey') String apiKey,
  );
}
