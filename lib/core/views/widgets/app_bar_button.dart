// import 'package:flutter/material.dart';

// import 'package:news_app/core/utils/theme/app_colors.dart';

// class AppBarButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final IconData iconData;
//   final bool hasPaddingBewteen;
//   final Color? color;  
//   const AppBarButton({super.key,this.color, required this.onTap, required this.iconData,  this.hasPaddingBewteen=false});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//               onTap: onTap,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.grey2
//                 ),
//                 child: Padding(
//                   padding:  EdgeInsets.all(hasPaddingBewteen? 8.0: 0.0),
//                   child: Icon(iconData, color: AppColors.black),
//                 ),
//               ),
//             );
//   }
// }

import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final bool hasPaddingBewteen;
  final Color? color; // هذا المتغير سيُستخدم الآن فعلياً
  final Color? backgroundColor;

  const AppBarButton({
    super.key,
    this.color,
    this.backgroundColor,
    required this.onTap,
    required this.iconData,
    this.hasPaddingBewteen = false,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من الثيم الحالي
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50), // لتحسين تأثير الضغط (Ripple)
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // ✅ خلفية الدائرة: رمادي فاتح في الوضع الفاتح، ورمادي غامق جداً في المظلم
          // ignore: deprecated_member_use
          color: backgroundColor ??
              // ignore: deprecated_member_use
              (isDarkMode ? Colors.white.withOpacity(0.1) : AppColors.grey2),
        ),
        child: Padding(
          padding: EdgeInsets.all(hasPaddingBewteen ? 8.0 : 0.0),
          child: Icon(
            iconData,
            // ✅ الأولوية للمتغير color إذا تم تمريره، وإلا نستخدم أبيض للمظلم وأسود للفاتح
            color: color ?? (isDarkMode ? Colors.white : AppColors.black),
          ),
        ),
      ),
    );
  }
}