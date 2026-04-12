
// import 'package:flutter/material.dart';
// import 'package:news_app/core/utils/theme/app_colors.dart';

// class SocialMediaBotton extends StatelessWidget {
//    SocialMediaBotton({
//     super.key,
//       this.text,
//        this.icon,
//         this.ontap,
//        this.isLoading = false
//        }){
//         assert(text!=null || isLoading==true || icon!=null);
//         }
// final String? text;
// final IconData? icon;
// final VoidCallback? ontap;
// final bool isLoading;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: ontap,
//       child: DecoratedBox(decoration: 
//       BoxDecoration(
       
//         border: Border.all(
//           color: AppColors.grey2
//           ),
//         borderRadius: BorderRadius.circular(16),
        
      
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child:isLoading? const CircularProgressIndicator.adaptive(): Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon),
//             const SizedBox(width: 16),
//             Text(text!),
//           ],
//         ),
//         ),
//       ),
//     );
//   }
// }
// // 

import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class SocialMediaButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLoading;

  const SocialMediaButton({
    super.key,
    this.text,
    this.icon,
    this.onTap,
    this.isLoading = false,
  }) : assert(isLoading || (text != null && icon != null));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon),
                    const SizedBox(width: 16),
                    Text(text!),
                  ],
                ),
        ),
      ),
    );
  }
}