import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(text,style:  GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
              ),),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
