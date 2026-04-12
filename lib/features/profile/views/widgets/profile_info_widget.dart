import 'package:flutter/material.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String username;
  final String email;

  const ProfileInfoWidget({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          username,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          email,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}