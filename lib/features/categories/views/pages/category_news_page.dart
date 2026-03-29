
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/features/categories/category_cubit/category_cubit.dart';
import 'package:news_app/features/categories/category_cubit/category_state.dart';
import 'package:news_app/features/categories/views/widgets/interests_shimmer.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';

class CategoryNewsPage extends StatelessWidget {
  final String category;

  const CategoryNewsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit()..getCategoryNews(category),
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.toUpperCase()),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBarButton(
              onTap: () {
                Navigator.pop(context);
              },
              iconData: Icons.arrow_back,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppBarButton(
                onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                iconData: Icons.search,
                hasPaddingBewteen: true,
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return InterestsShimmer(); 
                }

                if (state is CategoryLoaded) {
                  final articles = state.articles;
                  if (articles.isEmpty) {
                    return const Center(
                        child: Text("there is no news for this category"));
                  }

                  // نستخدم نفس RecommendationListWidget من الـ HomePage
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          "$category News",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        RecommendationListWidget(articles: articles),
                      ],
                    ),
                  );
                }

                if (state is CategoryError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}