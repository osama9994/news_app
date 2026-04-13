// import 'package:flutter/material.dart';

// class EmptyStateWidget extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String? subtitle;
//   final String? buttonText;
//   final VoidCallback? onButtonPressed;
//   final Widget? extraButton;

//   const EmptyStateWidget({
//     super.key,
//     required this.icon,
//     required this.title,
//     this.subtitle,
//     this.buttonText,
//     this.onButtonPressed,
//     this.extraButton,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 64, color: Colors.grey),
//             const SizedBox(height: 16),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//             if (subtitle != null) ...[
//               const SizedBox(height: 8),
//               Text(
//                 subtitle!,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//             ],
//             if (buttonText != null && onButtonPressed != null) ...[
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: onButtonPressed,
//                 icon: const Icon(Icons.refresh),
//                 label: Text(buttonText!),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ],
//             if (extraButton != null) ...[
//               const SizedBox(height: 16),
//               extraButton!,
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? extraButton;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.extraButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(Icons.refresh),
                label: Text(buttonText!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
            if (extraButton != null) ...[
              const SizedBox(height: 16),
              extraButton!,
            ],
          ],
        ),
      ),
    );
  }
}