import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';

class FavoritesServices {
  final localDatabaseHive = LocalDatabaseHive();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Article>> getFavoriteHive() async {
    final rawData = await localDatabaseHive.getData(AppConstants.favoritesKey);
    if (rawData == null || rawData is! List) return [];
    return rawData.cast<Article>();
  }

  Future<List<Article>> getFavoritesFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) => Article.fromJson(doc.data() as String)).toList();
  }

  Future<void> addFavoriteToFirebase(Article article) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(article.title)
        .set(article.toJson() as Map<String, dynamic>);
  }

  Future<void> removeFavoriteFromFirebase(Article article) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(article.title)
        .delete();
  }
}
// JUST WITH HIVE
// import 'package:news_app/core/models/article_model.dart';
// import 'package:news_app/core/services/local_database_hive.dart';
// import 'package:news_app/core/services/local_database_services.dart';
// import 'package:news_app/core/utils/app_constants.dart';

// class FavoritesServices {
//   final localDatabaseServices=LocalDatabaseServices();
//   final localDatabaseHive=LocalDatabaseHive();
//   Future<List<Article>>getFavorites()async{
// final favAritclesRaw=await localDatabaseServices.getStringList(AppConstants.favoritesKey);
// if(favAritclesRaw==null){
//   return [] ;
//   }
//   return favAritclesRaw.map((e)=>Article.fromJson(e)).toList();


//   }

// Future<List<Article>> getFavoriteHive() async {
//   final rawData = await localDatabaseHive.getData(
//     AppConstants.favoritesKey,
//   );

//   if (rawData == null || rawData is! List) {
//     return [];
//   }

//   return rawData.cast<Article>();
// }
// }