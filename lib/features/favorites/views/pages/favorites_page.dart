import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_cubit.dart';
import 'package:news_app/core/views/widgets/article_widget_item.dart';
import 'package:news_app/features/favorites/favorite_cubit/favorite_cubit.dart';
import 'package:news_app/features/favorites/favorite_cubit/favorite_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteActionsCubit = FavoriteActionsCubit();
    favoriteActionsCubit.initFavorites(); 
    return BlocProvider(
      create: (_) => FavoriteCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
              if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          else if (state is FavoriteLoaded) {
              final articles = state.articles;
              if (articles.isEmpty) return const Center(child: Text("No favorites yet!"));
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  itemCount: articles.length,
                  separatorBuilder: (_, __) => const Divider(height: 16),
                  itemBuilder: (_, index) => ArticleWidgetItem(article: articles[index], isSmaller: true),
                ),
              );
            } else if (state is FavoriteError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app/core/views/widgets/article_widget_item.dart';
// import 'package:news_app/features/favorites/favorite_cubit/favorite_cubit.dart';
// import 'package:news_app/features/favorites/favorite_cubit/favorite_state.dart';

// class FavoritesPage extends StatelessWidget {
//   const FavoritesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);
//     return Scaffold(
//       appBar: AppBar(title: const Text('Favorites')),
//       body: BlocBuilder<FavoriteCubit, FavoriteState>(
//         bloc: favoriteCubit,
//         buildWhen: (previous, current) =>
//             current is FavoriteLoading ||
//             current is FavoriteLoaded ||
//             current is FavoriteError,
//         builder: (context, state) {
//           if (state is FavoriteLoading) {
//             return CircularProgressIndicator.adaptive();
//           } else if (state is FavoriteLoaded) {
//             final articles = state.articles;
//             if (articles.isEmpty) {
//               return Center(child: Text("No favorites yet!"));
//             }
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView.separated(
//                 separatorBuilder: (context, index) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Divider(),
//                 ),
//                 itemCount: articles.length,
//                 itemBuilder: (_, index) {
//                   final article = articles[index];
//                   return ArticleWidgetItem(article: article, isSmaller: true,
//                   // isFavorite: true,
//                   );
//                 },
//               ),
//             );
//           } else if (state is FavoriteError) {
//             return Center(child: Text(state.message));
//           } else {
//             return SizedBox();
//           }
//         },
//       ),
//     );
//   }
// }
