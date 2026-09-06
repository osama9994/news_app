import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
import 'package:news_app/core/localization/language_cubit/language_state.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/features/categories/views/widgets/interests_shimmer.dart';
import 'package:news_app/features/home/view_all_cubit/view_all_news_cubit.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';

class RecommendationNewsAllPage extends StatelessWidget {
  const RecommendationNewsAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return BlocProvider(
      create: (_) => ViewAllNewsCubit()..loadRecommendationNews(),
      child: BlocListener<LanguageCubit, LanguageState>(
        listener: (context, state) {
          context.read<ViewAllNewsCubit>().applyCurrentLanguage();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(tr.text('recommendation')),
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
                
              ),
              const SizedBox(width: 12),
            ],
          ),
          drawer: const AppDrawer(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<ViewAllNewsCubit, ViewAllNewsState>(
                builder: (context, state) {
                  if (state is ViewAllNewsLoading) {
                    return InterestsShimmer();
                  }

                  if (state is ViewAllNewsLoaded) {
                    final articles = state.articles;
                    if (articles.isEmpty) {
                      return Center(
                        child: Text(tr.text('noRecommendationsAvailable')),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => context
                          .read<ViewAllNewsCubit>()
                          .loadRecommendationNews(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            RecommendationListWidget(articles: articles),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is ViewAllNewsError) {
                    return Center(child: Text(state.message));
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
