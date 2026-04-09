import 'package:flutter/material.dart';

class EmailWidget extends StatelessWidget {
  final String email;

  const EmailWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Text(
      email,
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}
