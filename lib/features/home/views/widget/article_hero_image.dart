import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticleHeroImage extends StatelessWidget {
  final String imageUrl;
  final double height;

  const ArticleHeroImage({
    super.key,
    required this.imageUrl,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      placeholder: (_, __) => Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.cover,
      ),
      errorWidget: (_, __, ___) => Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.cover,
      ),
    );
  }
}