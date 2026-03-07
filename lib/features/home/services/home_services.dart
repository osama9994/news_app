// import 'package:dio/dio.dart';
// import 'package:news_app/core/models/news_api_response.dart';
// import 'package:news_app/core/utils/app_constants.dart';

// import 'package:news_app/features/home/models/top_headlines_body.dart';

// class HomeServices {
//   final aDio=Dio();
//   Future<NewsApiResponse>getHeadLines(TopHeadlinesBody body)async{
//  try{
//   aDio.options.baseUrl=AppConstants.baseUrl;
//   final headers={
//     "Authorization":"Bearer ${AppConstants.apiKey}",
//   };
// final response= await aDio.get(
//   AppConstants.topHeadLines,
//   queryParameters: body.toMap(),
//   options: Options(
//     headers:headers, 
//   ),
//   );
// if(response.statusCode==200){
//   return NewsApiResponse.fromJson(response.data);
// }else{
// throw Exception(response.statusMessage);
// }
//  }
//  catch(e){
//   rethrow;
//  }
//   }
//   Future<NewsApiResponse> getEverything({
//   required int page,
//   required int pageSize,
// }) async {
//   try {
//     aDio.options.baseUrl = AppConstants.baseUrl;

//     final headers = {
//       "Authorization": "Bearer ${AppConstants.apiKey}",
//     };

//     final response = await aDio.get(
//       AppConstants.everything,
//       queryParameters: {
//         "q": "news",
//         "language": "en",
//         "sortBy": "publishedAt",
//         "page": page,
//         "pageSize": pageSize,
//       },
//       options: Options(headers: headers),
//     );

//     if (response.statusCode == 200) {
//       return NewsApiResponse.fromJson(response.data);
//     } else {
//       throw Exception(response.statusMessage);
//     }
//   } catch (e) {
//     rethrow;
//   }
// }
// }
import 'package:dio/dio.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';

class HomeServices {
  final Dio aDio = Dio();

  /// جلب الأخبار من API واحد
  Future<NewsApiResponse> getNews({
    required int page,
    required int pageSize,
  }) async {
    try {
      aDio.options.baseUrl = AppConstants.baseUrl;

      final headers = {
        "Authorization": "Bearer ${AppConstants.apiKey}",
      };

      final response = await aDio.get(
        AppConstants.everything,
        queryParameters: {
          "q": "news",
          "language": "en",
          "sortBy": "publishedAt",
          "page": page,
          "pageSize": pageSize,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return NewsApiResponse.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      rethrow;
    }
  }
}