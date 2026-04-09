import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class EditCategoriesPage extends StatefulWidget {
  const EditCategoriesPage({super.key});

  @override
  State<EditCategoriesPage> createState() => _EditCategoriesPageState();
}

class _EditCategoriesPageState extends State<EditCategoriesPage> {
  List<String> _selected = [];

  final List<Map<String, dynamic>> _categories = [
    {'id': 'sports', 'icon': '🏅', 'color': Color(0xFFFF6B6B)},
    {'id': 'technology', 'icon': '💻', 'color': Color(0xFF4ECDC4)},
    {'id': 'politics', 'icon': '🏛', 'color': Color(0xFF45B7D1)},
    {'id': 'business', 'icon': '💰', 'color': Color(0xFF96CEB4)},
    {'id': 'entertainment', 'icon': '🎬', 'color': Color(0xFFFFD93D)},
    {'id': 'science', 'icon': '🔬', 'color': Color(0xFFDDA0DD)},
    {'id': 'health', 'icon': '❤', 'color': Color(0xFFFF8B94)},
    {'id': 'general', 'icon': '📰', 'color': Color(0xFFB5EAD7)},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedCategories();
  }

  void _loadSavedCategories() {
    final box = Hive.box(AppConstants.localDatabaseBox);
    final saved = box.get('favoriteCategories');
    if (saved != null && saved is List) {
      setState(() {
        _selected = List<String>.from(saved);
      });
    }
  }

  void _toggle(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.text('editInterests'),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.text('updateYourInterests'),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr.text('chooseTopicsFollow'),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selected.contains(cat['id']);
                  return _CategoryTile(
                    icon: cat['icon'],
                    label: tr.category(cat['id']),
                    color: cat['color'],
                    isSelected: isSelected,
                    onTap: () => _toggle(cat['id']),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: _selected.isNotEmpty ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tr.topicCount(_selected.length),
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  listenWhen: (_, c) =>
                      c is CategoriesSaved || c is CategoriesError,
                  listener: (context, state) {
                    if (state is CategoriesSaved) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(tr.text('interestsUpdatedSuccess')),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else if (state is CategoriesError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  buildWhen: (_, c) =>
                      c is CategoriesSaving ||
                      c is CategoriesSaved ||
                      c is CategoriesError,
                  builder: (context, state) {
                    final isLoading = state is CategoriesSaving;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: (_selected.isEmpty || isLoading)
                            ? null
                            : () => context
                                .read<AuthCubit>()
                                .saveUserCategories(categories: _selected),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.grey2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                tr.text('saveChanges'),
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? color : color.withAlpha(30),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_rounded, size: 14, color: color),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(icon, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
