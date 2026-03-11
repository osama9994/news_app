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
    // ✅ شغّل الأخبار مرة واحدة عند فتح الشاشة
    context.read<HomeCubit>().getHomeNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // ✅ مباشرةً بدون BlocProvider
      key: _scaffoldKey,
              appBar: AppBar(
          backgroundColor: Colors.white,
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
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.notifications);
              },
              iconData: Icons.notifications_none_rounded,
              hasPaddingBewteen: true,
            ),
            const SizedBox(width: 12),
          ],
        ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
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
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        } else if (state is HomeLoaded) {
                          return CustomCarouselSlider(articles: state.breakingNews);
                        } else if (state is HomeError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
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
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      } else if (state is HomeLoaded) {
                        return RecommendationListWidget(articles: state.recommendationNews);
                      } else if (state is HomeError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class _HomePageState extends State<HomePage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) {
//         final homeCubit = HomeCubit();
//         homeCubit.getHomeNews(); // تحميل الأخبار مرة واحدة
//         return homeCubit;
//       },
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: AppBarButton(
//               onTap: () => _scaffoldKey.currentState!.openDrawer(),
//               iconData: Icons.menu,
//             ),
//           ),
//           actions: [
//             AppBarButton(
//               onTap: () => Navigator.pushNamed(context, AppRoutes.search),
//               iconData: Icons.search,
//               hasPaddingBewteen: true,
//             ),
//             const SizedBox(width: 12),
//             AppBarButton(
//               onTap: () {
//                 Navigator.pushNamed(context, AppRoutes.notifications);
//               },
//               iconData: Icons.notifications_none_rounded,
//               hasPaddingBewteen: true,
//             ),
//             const SizedBox(width: 12),
//           ],
//         ),
//         drawer: AppDrawer(),
//         body: SafeArea(
//           child: Builder(
//             builder: (context) {
//               final homeCubit = BlocProvider.of<HomeCubit>(context);
//               return RefreshIndicator(
//                 onRefresh: () async {
//                   await homeCubit.getHomeNews();
//                 },
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Column(
//                       children: [
//                         // ---------------- Breaking News ----------------
//                         TitleHeadlineWidget(
//                           title: "Breaking News",
//                           onTap: () => Navigator.pushNamed(
//                             context,
//                             AppRoutes.breakingNews,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         SizedBox(
//                           height: 280,
//                           child: BlocBuilder<HomeCubit, HomeState>(
//                             builder: (context, state) {
//                               if (state is HomeLoading) {
//                                 return const Center(
//                                   child: CircularProgressIndicator.adaptive(),
//                                 );
//                               } else if (state is HomeLoaded) {
//                                 return CustomCarouselSlider(
//                                   articles: state.breakingNews,
//                                 );
//                               } else if (state is HomeError) {
//                                 return Center(child: Text(state.message));
//                               } else {
//                                 return const SizedBox.shrink();
//                               }
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // ---------------- Recommendation ----------------
//                         TitleHeadlineWidget(
//                           title: "Recommendation",
//                           onTap: () => Navigator.pushNamed(
//                             context,
//                             AppRoutes.recommendationNews,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         BlocBuilder<HomeCubit, HomeState>(
//                           builder: (context, state) {
//                             if (state is HomeLoading) {
//                               return const Center(
//                                 child: CircularProgressIndicator.adaptive(),
//                               );
//                             } else if (state is HomeLoaded) {
//                               return RecommendationListWidget(
//                                 articles: state.recommendationNews,
//                               );
//                             } else if (state is HomeError) {
//                               return Center(child: Text(state.message));
//                             } else {
//                               return const SizedBox.shrink();
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }