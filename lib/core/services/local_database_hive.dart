
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/utils/app_constants.dart';


class LocalDatabaseHive {
 static void initHive()async{
    Hive.initFlutter();
    Hive.registerAdapter(ArticleAdapter());
    Hive.registerAdapter(SourceAdapter());
   await Hive.openBox(AppConstants.localDatabaseBox);
}
Future<void>saveData<T>(String key,T value)async{
  final box= Hive.box(AppConstants.localDatabaseBox);
await  box.put(key, value);
}
Future<T> getData<T>(String key )async{
  final box=await Hive.openBox(AppConstants.localDatabaseBox);
  return box.get(key);
}
Future<void>deleteData(String key)async{
  final box=await Hive.openBox(AppConstants.localDatabaseBox);
 await box.delete(key);
}

}