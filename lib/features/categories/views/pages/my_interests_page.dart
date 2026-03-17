import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/features/categories/views/widgets/category_tab_widget.dart';
import 'package:news_app/features/categories/views/widgets/empty_interests_widget.dart';

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

  String _capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
@override
Widget build(BuildContext context) {
  // الحصول على الثيم الحالي لسهولة الاستخدام
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Scaffold(
    // ✅ تغيير من Colors.white إلى لون خلفية الثيم
    backgroundColor: theme.scaffoldBackgroundColor,
    appBar: AppBar(
      // ✅ جعل لون الـ AppBar يتبع الثيم (تلقائياً من AppTheme)
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBarButton(
          onTap: () => Navigator.pop(context),
          iconData: Icons.arrow_back,
          // ✅ تغيير من Colors.black إلى لون الأيقونات في الثيم
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      title: Text(
        "My Interests",
        style: TextStyle(
          // ✅ تغيير من Colors.black إلى لون النص في الثيم
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        AppBarButton(
          onTap: () => Navigator.pushNamed(context, AppRoutes.search),
          iconData: Icons.search,
          // ✅ لون ديناميكي للزر
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
              // ✅ لون التبويب غير المختار (رمادي فاتح في المظلم، ورمادي عادي في الفاتح)
              unselectedLabelColor: isDarkMode ? Colors.grey[400] : AppColors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: _categories
                  .map((cat) => Tab(text: _capitalize(cat)))
                  .toList(),
            ),
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : _categories.isEmpty
            ? const EmptyInterestsWidget()
            : TabBarView(
                controller: _tabController,
                children: _categories
                    .map((cat) => CategoryTabWidget(category: cat))
                    .toList(),
              ),
  );
}
}