import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class OnboardingCategoryPage extends StatefulWidget {
  const OnboardingCategoryPage({super.key});

  @override
  State<OnboardingCategoryPage> createState() => _OnboardingCategoryPageState();
}

class _OnboardingCategoryPageState extends State<OnboardingCategoryPage>
    with TickerProviderStateMixin {
  final List<String> _selected = [];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _categories = [
    {'id': 'sports',        'label': 'Sports',        'icon': '🏅', 'color': Color(0xFFFF6B6B)},
    {'id': 'technology',    'label': 'Technology',    'icon': '💻', 'color': Color(0xFF4ECDC4)},
    {'id': 'politics',      'label': 'Politics',      'icon': '🌍', 'color': Color(0xFF45B7D1)},
    {'id': 'business',      'label': 'Business',      'icon': '💰', 'color': Color(0xFF96CEB4)},
    {'id': 'entertainment', 'label': 'Entertainment', 'icon': '🎬', 'color': Color(0xFFFFD93D)},
    {'id': 'science',       'label': 'Science',       'icon': '🔬', 'color': Color(0xFFDDA0DD)},
    {'id': 'health',        'label': 'Health',        'icon': '❤️', 'color': Color(0xFFFF8B94)},
    {'id': 'general',       'label': 'General',       'icon': '📰', 'color': Color(0xFFB5EAD7)},
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _toggle(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    Row(
                      children: List.generate(3, (i) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          height: 4,
                          decoration: BoxDecoration(
                            color: i == 2 ? AppColors.primary : AppColors.grey2,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "What interests\nyou the most?",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Pick your favorite topics — we'll send you\npersonalized news and notifications.",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.grey,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Grid ──
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
                        label: cat['label'],
                        color: cat['color'],
                        isSelected: isSelected,
                        onTap: () => _toggle(cat['id']),
                      );
                    },
                  ),
                ),
              ),

              // ── Bottom Section ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: Column(
                  children: [
                    // Counter
                    AnimatedOpacity(
                      opacity: _selected.isNotEmpty ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              "${_selected.length} topic${_selected.length > 1 ? 's' : ''} selected",
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

                    // Continue Button
                    BlocConsumer<AuthCubit, AuthState>(
                      listenWhen: (_, c) =>
                          c is CategoriesSaved || c is CategoriesError,
                      listener: (context, state) {
                        if (state is CategoriesSaved) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.home,
                            (route) => false,
                          );
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
                                    "Get Started",
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

                    // Skip
                    TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      ),
                      child: Text(
                        "Skip for now",
                        style: GoogleFonts.poppins(
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Category Tile ──
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
          // ignore: deprecated_member_use
          color: isSelected ? color : color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                )]
              : [],
        ),
        child: Stack(
          children: [
            // Checkmark
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

            // Content
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