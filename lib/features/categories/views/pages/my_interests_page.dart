import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/features/categories/views/widgets/category_tab_widget.dart';
import 'package:news_app/features/categories/views/widgets/empty_interests_widget.dart';
import 'package:news_app/features/categories/views/widgets/interests_shimmer.dart';

class MyInterestsPage extends StatefulWidget {
  const MyInterestsPage({super.key});

  @override
  State<MyInterestsPage> createState() => _MyInterestsPageState();
}

class _MyInterestsPageState extends State<MyInterestsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    final box = Hive.box(AppConstants.localDatabaseBox);
    final saved = box.get('favoriteCategories');

    setState(() {
      _categories = saved != null ? List<String>.from(saved) : [];
      _isLoading = false;
    });

    if (_categories.isNotEmpty) {
      _tabController = TabController(
        length: _categories.length,
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    if (_categories.isNotEmpty) _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final tr = context.tr;

    return Scaffold(
      body: _isLoading
          ? InterestsShimmer()
          : _categories.isEmpty
              ? const EmptyInterestsWidget()
              : TabBarView(
                  controller: _tabController,
                  children: _categories
                      .map((cat) => CategoryTabWidget(category: cat))
                      .toList(),
                ),
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBarButton(
            onTap: () => Navigator.pop(context),
            iconData: Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          tr.text('myInterests'),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          AppBarButton(
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
            iconData: Icons.search,
            color: isDarkMode ? Colors.white : Colors.black,
            hasPaddingBewteen: true,
          ),
          const SizedBox(width: 12),
        ],
        bottom: _isLoading || _categories.isEmpty
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor:
                    isDarkMode ? Colors.grey[400] : AppColors.grey,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: _categories
                    .map((cat) => Tab(text: tr.category(cat)))
                    .toList(),
              ),
      ),
    );
  }
}
