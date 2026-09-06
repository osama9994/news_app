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
    final categories = saved != null ? List<String>.from(saved) : <String>[];

    if (categories.isNotEmpty) {
      _tabController = TabController(
        length: categories.length,
        vsync: this,
      );
    }

    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    if (_categories.isNotEmpty) _tabController.dispose();
    super.dispose();
  }

  bool get _hasCategories => _categories.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBarButton(
            onTap: () => Navigator.pop(context),
            iconData: Icons.arrow_back,
            color: iconColor,
          ),
        ),
        title: Text(
          tr.text('myInterests'),
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          AppBarButton(
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
            iconData: Icons.search,
            color: iconColor,
          ),
          const SizedBox(width: 12),
        ],
        bottom: _isLoading || !_hasCategories
            ? null
            : _buildTabBar(tr, iconColor),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const InterestsShimmer();
    if (!_hasCategories) return const EmptyInterestsWidget();

    return TabBarView(
      controller: _tabController,
      children: _categories
          .map((cat) => CategoryTabWidget(category: cat))
          .toList(),
    );
  }

  TabBar _buildTabBar(dynamic tr, Color iconColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: AppColors.primary,
      tabAlignment: TabAlignment.center,
      labelColor: AppColors.primary,
      unselectedLabelColor: isDarkMode ? Colors.grey[400] : AppColors.grey,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      tabs: _categories
          .map((cat) => Tab(text: tr.category(cat)))
          .toList(),
    );
  }
}