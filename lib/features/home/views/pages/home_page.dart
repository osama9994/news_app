// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
// import 'package:news_app/core/localization/language_cubit/language_state.dart';
// import 'package:news_app/core/localization/app_strings.dart';
// import 'package:news_app/core/utils/route/app_routes.dart';
// import 'package:news_app/core/views/widgets/app_bar_button.dart';
// import 'package:news_app/core/views/widgets/app_drawer.dart';
// import 'package:news_app/core/views/widgets/empty_state_widget.dart';
// import 'package:news_app/features/home/home_cubit/home_cubit.dart';
// import 'package:news_app/features/home/views/widget/custom_carousel_slider.dart';
// import 'package:news_app/features/home/views/widget/home_shimmer.dart';
// import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';
// import 'package:news_app/features/home/views/widget/title_headline_widget.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     context.read<HomeCubit>().getHomeNews();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final tr = context.tr;

//     return BlocListener<LanguageCubit, LanguageState>(
//       listener: (context, state) {
//         context.read<HomeCubit>().applyCurrentLanguage();
//       },
//       child: Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: theme.scaffoldBackgroundColor,
//         appBar: AppBar(
//           backgroundColor: theme.appBarTheme.backgroundColor,
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
//               onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
//               iconData: Icons.notifications_none_rounded,
//               hasPaddingBewteen: true,
//             ),
//             const SizedBox(width: 12),
//           ],
//         ),
//         drawer: const AppDrawer(),
//         body: SafeArea(
//           child: BlocBuilder<HomeCubit, HomeState>(
//             builder: (context, state) {
//               if (state is HomeLoading) {
//                 return HomeShimmer();
//               }

//               if (state is HomeError) {
//                 return EmptyStateWidget(
//                   icon: state.message.contains("No Internet")
//                       ? Icons.cloud_off
//                       : Icons.error_outline,
//                   title: tr.text('offlineTitle'),
//                   subtitle: tr.text('offlineSubtitle'),
//                   buttonText: tr.text('retry'),
//                   onButtonPressed: () => context.read<HomeCubit>().getHomeNews(),
//                   extraButton: TextButton(
//                     onPressed: () =>
//                         Navigator.pushNamed(context, AppRoutes.favorites),
//                     child: Text(
//                       tr.text('goToFavorites'),
//                       style: const TextStyle(
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 );
//               }

//               if (state is HomeLoaded) {
//                 return RefreshIndicator(
//                   onRefresh: () async =>
//                       await context.read<HomeCubit>().getHomeNews(),
//                   child: SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Column(
//                         children: [
//                           TitleHeadlineWidget(
//                             title: tr.text('breakingNews'),
//                             onTap: () => Navigator.pushNamed(
//                               context,
//                               AppRoutes.breakingNews,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           SizedBox(
//                             height: 280,
//                             child: CustomCarouselSlider(
//                               articles: state.breakingNews,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           TitleHeadlineWidget(
//                             title: tr.text('recommendation'),
//                             onTap: () => Navigator.pushNamed(
//                               context,
//                               AppRoutes.recommendationNews,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           RecommendationListWidget(
//                             articles: state.recommendationNews,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }

//               return const SizedBox.shrink();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
import 'package:news_app/core/localization/language_cubit/language_state.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';
import 'package:news_app/features/home/views/widget/home_app_bar.dart';
import 'package:news_app/features/home/views/widget/home_error_body.dart';
import 'package:news_app/features/home/views/widget/home_loaded_body.dart';
import 'package:news_app/features/home/views/widget/home_shimmer.dart';


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
    return BlocListener<LanguageCubit, LanguageState>(
      listener: (_, __) => context.read<HomeCubit>().applyCurrentLanguage(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: HomeAppBar(scaffoldKey: _scaffoldKey),
        drawer: const AppDrawer(),
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) => switch (state) {
              HomeLoading() => HomeShimmer(),
              HomeError()   => HomeErrorBody(state: state),
              HomeLoaded()  => HomeLoadedBody(state: state),
              _             => const SizedBox.shrink(),
            },
          ),
        ),
      ),
    );
  }
}