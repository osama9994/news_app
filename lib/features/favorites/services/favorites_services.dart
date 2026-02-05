import 'package:news_app/core/models/new_api_response.dart';
import 'package:news_app/core/services/local_database_services.dart';
import 'package:news_app/core/utils/app_constants.dart';

class FavoritesServices {
  final localDatabaseServices=LocalDatabaseServices();
  Future<List<Article>>getFavorites()async{
final favAritclesRaw=await localDatabaseServices.getStringList(AppConstants.favoritesKey);
if(favAritclesRaw==null){
  return [] ;
  }
  return favAritclesRaw.map((e)=>Article.fromJson(e)).toList();


  }
}