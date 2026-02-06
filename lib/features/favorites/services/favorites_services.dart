import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/services/local_database_services.dart';
import 'package:news_app/core/utils/app_constants.dart';

class FavoritesServices {
  final localDatabaseServices=LocalDatabaseServices();
  final localDatabaseHive=LocalDatabaseHive();
  Future<List<Article>>getFavorites()async{
final favAritclesRaw=await localDatabaseServices.getStringList(AppConstants.favoritesKey);
if(favAritclesRaw==null){
  return [] ;
  }
  return favAritclesRaw.map((e)=>Article.fromJson(e)).toList();


  }

  Future<List<Article>>getFavoriteHive()async{
    final favorites =  await localDatabaseHive.getData<List<Article>?>(
  AppConstants.favoritesKey
 );
 if(favorites==null){
  return [];
 }
    return favorites.map((e) => e ).toList();
  
}}