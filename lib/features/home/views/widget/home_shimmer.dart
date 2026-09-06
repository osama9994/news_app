// home_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // add shimmer: ^3.0.0 to pubspec.yaml

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Breaking News header ─────────────────────────
            const SizedBox(height: 12),
            _ShimmerRow(widths: const [130, 60]),
            const SizedBox(height: 10),

            // ── Carousel placeholder ─────────────────────────
            _ShimmerBox(height: 220, radius: 16),
            const SizedBox(height: 20),

            // ── Recommendation header ────────────────────────
            _ShimmerRow(widths: const [150, 60]),
            const SizedBox(height: 10),

            // ── Recommendation cards ─────────────────────────
            for (int i = 0; i < 4; i++) ...[
              const _RecommendationShimmerCard(),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Section title row: label + "See all" ──────────────────
class _ShimmerRow extends StatelessWidget {
  final List<double> widths;
  const _ShimmerRow({required this.widths});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widths
          .map((w) => _ShimmerBox(width: w, height: 16))
          .toList(),
    );
  }
}

// ─── Single recommendation card ────────────────────────────
class _RecommendationShimmerCard extends StatelessWidget {
  const _RecommendationShimmerCard();

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

// ─── Generic shimmer block ──────────────────────────────────
class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double? widthFactor; // fraction of parent width
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
    return LayoutBuilder(builder: (ctx, constraints) {
      final w = width ?? (constraints.maxWidth * (widthFactor ?? 1.0));
      return Container(
        width: w,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    });
  }
}
