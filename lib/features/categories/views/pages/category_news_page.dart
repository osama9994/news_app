// 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
import 'package:news_app/core/localization/language_cubit/language_state.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/core/views/widgets/empty_state_widget.dart';
import 'package:news_app/features/categories/category_cubit/category_cubit.dart';
import 'package:news_app/features/categories/category_cubit/category_state.dart';
import 'package:news_app/features/categories/views/widgets/interests_shimmer.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';

class CategoryNewsPage extends StatelessWidget {
  final String category;

  const CategoryNewsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit()..getCategoryNews(category),
      child: BlocListener<LanguageCubit, LanguageState>(
        listener: (context, _) =>
            context.read<CategoryCubit>().applyCurrentLanguage(),
        child: Scaffold(
          appBar: _buildAppBar(context),
          drawer: const AppDrawer(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) => _buildState(context, state),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final tr = context.tr;

    return AppBar(
      title: Text(tr.category(category).toUpperCase()),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBarButton(
          onTap: () => Navigator.pop(context),
          iconData: Icons.arrow_back,
        ),
      ),
      actions: [
        AppBarButton(
          onTap: () => Navigator.pushNamed(context, AppRoutes.search),
          iconData: Icons.search,
          hasPaddingBetween: true,
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildState(BuildContext context, CategoryState state) {
    if (state is CategoryLoading) return const InterestsShimmer();
    if (state is CategoryError)  return _buildError(context, state);
    if (state is CategoryLoaded) return _buildLoaded(context, state);
    return const SizedBox.shrink();
  }

  Widget _buildLoaded(BuildContext context, CategoryLoaded state) {
    final tr = context.tr;

    if (state.articles.isEmpty) {
      return Center(child: Text(tr.text('noNewsForCategory')));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            tr.categoryNewsTitle(category),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          RecommendationListWidget(articles: state.articles),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, CategoryError state) {
    final tr = context.tr;

    return EmptyStateWidget(
      icon: state.message.contains('No Internet')
          ? Icons.cloud_off
          : Icons.error_outline,
      title: tr.text('offlineTitle'),
      subtitle: tr.text('offlineSubtitle'),
      buttonText: tr.text('retry'),
      onButtonPressed: () =>
          context.read<CategoryCubit>().getCategoryNews(category),
      extraButton: TextButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
        child: Text(
          tr.text('goToFavorites'),
          style: const TextStyle(decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}