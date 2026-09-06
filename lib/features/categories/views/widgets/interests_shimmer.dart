

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InterestsShimmer extends StatelessWidget {
  const InterestsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor      = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1200),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const _ShimmerBox(height: 20, width: 180),
              const SizedBox(height: 16),
              ...List.generate(
                6,
                (_) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: _ArticleCardShimmer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleCardShimmer extends StatelessWidget {
  const _ArticleCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _ShimmerBox(width: 150, height: 150, radius: 12),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ShimmerBox(height: 14, widthFactor: 0.9),
              SizedBox(height: 8),
              _ShimmerBox(height: 14, widthFactor: 0.7),
              SizedBox(height: 8),
              _ShimmerBox(height: 12, widthFactor: 0.5),
            ],
          ),
        ),
      ],
    );
  }
}

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final calculatedWidth =
            width ?? constraints.maxWidth * (widthFactor ?? 1);

        return Container(
          width: calculatedWidth,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(radius),
          ),
        );
      },
    );
  }
}