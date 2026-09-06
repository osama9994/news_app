import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/empty_state_widget.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';

class HomeErrorBody extends StatelessWidget {
  final HomeError state;

  const HomeErrorBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final isNoInternet = state.message.contains('No Internet');

    return EmptyStateWidget(
      icon: isNoInternet ? Icons.cloud_off : Icons.error_outline,
      title: tr.text('offlineTitle'),
      subtitle: tr.text('offlineSubtitle'),
      buttonText: tr.text('retry'),
      onButtonPressed: () => context.read<HomeCubit>().getHomeNews(),
      extraButton: TextButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
        child: Text(
          tr.text('goToFavorites'),
          style: const TextStyle(decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}