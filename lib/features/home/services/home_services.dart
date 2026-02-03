import 'package:dio/dio.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/core/models/new_api_response.dart';
import 'package:news_app/features/home/models/top_headlines_body.dart';

class HomeServices {
  final aDio=Dio();
  Future<NewApiResponse>getHeadLines(TopHeadlinesBody body)async{
 try{
  aDio.options.baseUrl=AppConstants.baseUrl;
  final headers={
    "Authorization":"Bearer ${AppConstants.apiKey}",
  };
final response= await aDio.get(
  AppConstants.topHeadLines,
  queryParameters: body.toMap(),
  options: Options(
    headers:headers, 
  ),
  );
if(response.statusCode==200){
  return NewApiResponse.fromMap(response.data);
}else{
throw Exception(response.statusMessage);
}
 }
 catch(e){
  rethrow;
 }
  }
}