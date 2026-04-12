import 'package:flutter/material.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeAppBar({super.key, required this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBarButton(
          onTap: () => scaffoldKey.currentState?.openDrawer(),
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
    );
  }
}