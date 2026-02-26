import 'package:flutter/material.dart';

class UsernameWidget extends StatelessWidget {
  final String username;


  const UsernameWidget({
    super.key,
    required this.username,
   
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
       
      ],
    );
  }
}