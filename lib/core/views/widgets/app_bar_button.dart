import 'package:flutter/material.dart';

import 'package:news_app/core/utils/theme/app_colors.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final bool hasPaddingBewteen;
  final Color? color;  
  const AppBarButton({super.key,this.color, required this.onTap, required this.iconData,  this.hasPaddingBewteen=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
              onTap: onTap,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey2
                ),
                child: Padding(
                  padding:  EdgeInsets.all(hasPaddingBewteen? 8.0: 0.0),
                  child: Icon(iconData, color: AppColors.black),
                ),
              ),
            );
  }
}