// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class InterestsShimmer extends StatelessWidget {
//   const InterestsShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final base = Theme.of(context).colorScheme.surfaceContainerHighest;
//     final highlight = Theme.of(context).colorScheme.surface;
//     final divider = Theme.of(context).dividerColor;

//     return Shimmer.fromColors(
//       baseColor: base,
//       highlightColor: highlight,
//       child: SingleChildScrollView(
//         physics: const NeverScrollableScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Tab pills ──────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 children: [72.0, 88.0, 60.0, 80.0]
//                     .map((w) => Padding(
//                           padding: const EdgeInsets.only(right: 10),
//                           child: _ShimmerBox(width: w, height: 32, radius: 20),
//                         ))
//                     .toList(),
//               ),
//             ),
//             Divider(height: 1, color: divider),

//             // ── Featured article (image on top) ───────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _ShimmerBox(widthFactor: 1, height: 190, radius: 14),
//                   const SizedBox(height: 12),
//                   _ShimmerBox(widthFactor: 0.4, height: 13),
//                   const SizedBox(height: 10),
//                   _ShimmerBox(widthFactor: 0.95, height: 18),
//                   const SizedBox(height: 6),
//                   _ShimmerBox(widthFactor: 0.75, height: 18),
//                   const SizedBox(height: 10),
//                   _ShimmerBox(widthFactor: 0.5, height: 12),
//                 ],
//               ),
//             ),
//             Divider(height: 32, indent: 16, endIndent: 16, color: divider),

//             // ── Regular article rows ───────────────────────
//             ...[
//               [0.45, 0.95, 0.80, 0.55],
//               [0.38, 0.90, 0.70, 0.50],
//               [0.50, 0.88, 0.65, 0.45],
//             ].map((factors) => Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: _ArticleRowShimmer(widthFactors: factors),
//                     ),
//                     Divider(
//                         height: 32,
//                         indent: 16,
//                         endIndent: 16,
//                         color: divider),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Article row: text lines left + thumbnail right ──────────
// class _ArticleRowShimmer extends StatelessWidget {
//   final List<double> widthFactors; // [category, title1, title2, meta]
//   const _ArticleRowShimmer({required this.widthFactors});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _ShimmerBox(widthFactor: widthFactors[0], height: 13),
//               const SizedBox(height: 8),
//               _ShimmerBox(widthFactor: widthFactors[1], height: 16),
//               const SizedBox(height: 6),
//               _ShimmerBox(widthFactor: widthFactors[2], height: 16),
//               const SizedBox(height: 8),
//               _ShimmerBox(widthFactor: widthFactors[3], height: 12),
//             ],
//           ),
//         ),
//         const SizedBox(width: 12),
//         _ShimmerBox(width: 90, height: 90, radius: 12),
//       ],
//     );
//   }
// }

// // ── Generic shimmer block ────────────────────────────────────
// class _ShimmerBox extends StatelessWidget {
//   final double? width;
//   final double? widthFactor;
//   final double height;
//   final double radius;

//   const _ShimmerBox({
//     this.width,
//     this.widthFactor,
//     required this.height,
//     this.radius = 8,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (ctx, constraints) {
//       final w = width ?? constraints.maxWidth * (widthFactor ?? 1.0);
//       return Container(
//         width: w,
//         height: height,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(radius),
//         ),
//       );
//     });
//   }
// }



import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InterestsShimmer extends StatelessWidget {
  const InterestsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final base = theme.brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[300]!;

    final highlight = theme.brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1200),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            /// 🔥 Title (category name)
            const _ShimmerBox(height: 20, width: 180),
            const SizedBox(height: 16),

            /// 🔥 Articles list (نفس RecommendationListWidget)
            ...List.generate(6, (index) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: _ArticleCardShimmer(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
// ─── Single recommendation card ────────────────────────────
class _ArticleCardShimmer extends StatelessWidget {
  const _ArticleCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ShimmerBox(width: 150, height: 150, radius: 12),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(height: 14, widthFactor: 0.9),
              const SizedBox(height: 8),
              _ShimmerBox(height: 14, widthFactor: 0.7),
              const SizedBox(height: 8),
              _ShimmerBox(height: 12, widthFactor: 0.5),
            ],
          ),
        ),
      ],
    );
  }
}

/// ── Generic Box ───────────────────────────────────────────
class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double? widthFactor;
  final double height;
  final double radius;

  const _ShimmerBox({
    this.width,
    this.widthFactor,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final calculatedWidth =
            width ?? constraints.maxWidth * (widthFactor ?? 1);

        return Container(
          width: calculatedWidth,
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(radius),
          ),
        );
      },
    );
  }
}
