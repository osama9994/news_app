
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_strings.dart';
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
        builder: (context, state) => _buildState(context, state),
      ),
    );
  }

  Widget _buildState(BuildContext context, CategoryState state) {
    if (state is CategoryLoading) return const InterestsShimmer();
    if (state is CategoryLoaded) return _buildLoaded(context, state);
    if (state is CategoryError) return _buildError(context, state);
    return const SizedBox.shrink();
  }

  Widget _buildLoaded(BuildContext context, CategoryLoaded state) {
    if (state.articles.isEmpty) return _buildEmpty(context);

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

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Text(
        context.tr.text('noNewsForTopic'),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildError(BuildContext context, CategoryError state) {
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
            child: Text(context.tr.text('retry')),
          ),
        ],
      ),
    );
  }
}