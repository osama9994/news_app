import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/categories/category_cubit/category_cubit.dart';
import 'package:news_app/features/categories/category_cubit/category_state.dart';
import 'package:news_app/features/categories/views/widgets/interests_shimmer.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';

class CategoryTabWidget extends StatelessWidget {
  final String category;

  const CategoryTabWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit()..getCategoryNews(category),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InterestsShimmer(),
            );
          }

          if (state is CategoryLoaded) {
            if (state.articles.isEmpty) {
              return const Center(
                child: Text(
                  "No news available for this topic.",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<CategoryCubit>().getCategoryNews(category),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      RecommendationListWidget(articles: state.articles),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is CategoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CategoryCubit>().getCategoryNews(category),
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}