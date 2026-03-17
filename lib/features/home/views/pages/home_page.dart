
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';
import 'package:news_app/features/home/views/widget/custom_carousel_slider.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';
import 'package:news_app/features/home/views/widget/title_headline_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getHomeNews();
  }

@override
Widget build(BuildContext context) {
  // ✅ تعريف متغيرات الثيم لتسهيل الاستخدام
  final theme = Theme.of(context);
  return Scaffold(
    key: _scaffoldKey,
   
    backgroundColor: theme.scaffoldBackgroundColor, 
    
    appBar: AppBar(
      // ✅ 2. تغيير اللون الأبيض إلى لون الثيم
      backgroundColor: theme.appBarTheme.backgroundColor, 
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBarButton(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          iconData: Icons.menu,
       
        ),
      ),
      actions: [
        AppBarButton(
          onTap: () => Navigator.pushNamed(context, AppRoutes.search),
          iconData: Icons.search,
          hasPaddingBewteen: true,
        ),
        const SizedBox(width: 12),
        AppBarButton(
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          iconData: Icons.notifications_none_rounded,
          hasPaddingBewteen: true,
        ),
        const SizedBox(width: 12),
      ],
    ),
      drawer: AppDrawer(),
      // ✅ BlocBuilder واحد يغلّف كل الـ body
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {

            // ✅ Loading واحد للشاشة كاملة
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            // ✅ Error واحد للشاشة كاملة
            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(state.message),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<HomeCubit>().getHomeNews(),
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              );
            }

            // ✅ Loaded — عرض كل المحتوى
            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<HomeCubit>().getHomeNews();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        TitleHeadlineWidget(
                          title: "Breaking News",
                          onTap: () => Navigator.pushNamed(
                            context, AppRoutes.breakingNews,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 280,
                          child: CustomCarouselSlider(
                            articles: state.breakingNews,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TitleHeadlineWidget(
                          title: "Recommendation",
                          onTap: () => Navigator.pushNamed(
                            context, AppRoutes.recommendationNews,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RecommendationListWidget(
                          articles: state.recommendationNews,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}