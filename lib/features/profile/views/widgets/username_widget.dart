import 'package:flutter/material.dart';

class UsernameWidget extends StatelessWidget {
  final String username;
  final VoidCallback onEdit;

  const UsernameWidget({
    super.key,
    required this.username,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          username,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.blueAccent),
          onPressed: onEdit,
        ),
      ],
    );
  }
}