import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_cubit.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/features/favorites/services/favorites_services.dart';


part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial()){
    favoriteActionsCubit.stream.listen((state){
      if(state is FavoriteRemoved){
        getFavoriteItmes();
      }
    });
  }
final favoritesServices=FavoritesServices();
final favoriteActionsCubit=FavoriteActionsCubit();
  Future<void>getFavoriteItmes()async{
    emit(FavoriteLoading());
    try{
      final favArtciles=await favoritesServices.getFavoriteHive();
      for(int index=0;index<favArtciles.length;index++ ){
        var article=favArtciles[index];
        article=article.copyWith(isFavorite: true);
        favArtciles[index]=article;
      }

emit(FavoriteLoaded(favArtciles));
    }catch(e){
      emit(FavoriteError(e.toString()));
    }
  }
}
