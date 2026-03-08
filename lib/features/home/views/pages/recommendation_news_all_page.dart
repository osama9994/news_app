import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/features/home/view_all_cubit/view_all_news_cubit.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';

class RecommendationNewsAllPage extends StatelessWidget {
  const RecommendationNewsAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ViewAllNewsCubit()..loadRecommendationNews(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Recommendation",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
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
              hasPaddingBewteen: true,
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
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (state is ViewAllNewsLoaded) {
                  final articles = state.articles;
                  if (articles.isEmpty) {
                    return const Center(
                      child: Text("No recommendations available"),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<ViewAllNewsCubit>().loadRecommendationNews(),
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
    );
  }
}
