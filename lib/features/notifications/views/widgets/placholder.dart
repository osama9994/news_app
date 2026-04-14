import 'package:flutter/material.dart';

// ignore: unused_element
class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.notifications_rounded,
        color: Colors.blue,
        size: 28,
      ),
    );
  }
}