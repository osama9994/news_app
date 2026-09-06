import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/views/widgets/article_widget_item.dart';
import 'package:news_app/features/categories/views/widgets/interests_shimmer.dart';
import 'package:news_app/features/favorites/favorite_cubit/favorite_cubit.dart';
import 'package:news_app/features/favorites/favorite_cubit/favorite_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(tr.text('favorites'))),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return InterestsShimmer();
          } else if (state is FavoriteLoaded) {
            final articles = state.articles.reversed.toList();
            if (articles.isEmpty) {
              return Center(child: Text(tr.text('noFavoritesYet')));
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: articles.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (_, index) => ArticleWidgetItem(
                  article: articles[index],
                  isSmaller: true,
                ),
              ),
            );
          } else if (state is FavoriteError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
