import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';
import 'package:news_app/features/home/views/widget/custom_carousel_slider.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';
import 'package:news_app/features/home/views/widget/title_headline_widget.dart';

class HomeLoadedBody extends StatelessWidget {
  final HomeLoaded state;

  const HomeLoadedBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().getHomeNews(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TitleHeadlineWidget(
                title: tr.text('breakingNews'),
                onTap: () => Navigator.pushNamed(context, AppRoutes.breakingNews),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 280,
                child: CustomCarouselSlider(articles: state.breakingNews),
              ),
              const SizedBox(height: 16),
              TitleHeadlineWidget(
                title: tr.text('recommendation'),
                onTap: () => Navigator.pushNamed(context, AppRoutes.recommendationNews),
              ),
              const SizedBox(height: 8),
              RecommendationListWidget(articles: state.recommendationNews),
            ],
          ),
        ),
      ),
    );
  }
}