import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/login/views/widgets/main_button.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Drawer(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 150,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.primary),
                child: Center(
                  child: Text(
                    "News App",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title:
                  Text("Home", style: Theme.of(context).textTheme.titleMedium),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.favorite_rounded),
              title: Text(
                "Favorites",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.favorites);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                "Profile",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const Divider(),
            BlocConsumer<AuthCubit, AuthState>(
              bloc: cubit,
              listenWhen: (previous, current) =>
              current is AuthLoggedOut||
              current is AuthLogOutError,
              listener: (context, state) {
                if(state is AuthLoggedOut){
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.loginRoute, (route) => false);
                  
                }
                else if(state is AuthLogOutError){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              buildWhen: (previous, current) =>current is AuthLogingOut ,
              builder: (context, state) {
                if(state is AuthLogingOut){
                return MainButton(isLoading: true,
                );

                }
                return ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: Text(
                    "log out",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onTap: () async {
                    await cubit.logout();
                  },
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
