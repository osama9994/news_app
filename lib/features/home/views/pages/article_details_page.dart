import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/features/home/models/top_headlines_api_response.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Article article;
  const ArticleDetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final parsedDate = DateTime.parse(
      article.publishedAt ?? DateTime.now().toString(),
    );
    final formatedDate = DateFormat.yMMMd().format(parsedDate);
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: article.urlToImage ?? "",
            width: double.infinity,
            height: size.height * 0.5,
            fit: BoxFit.cover,

            placeholder: (context, url) =>
                Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),

            errorWidget: (context, url, error) =>
                Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.center,
                begin: Alignment.bottomCenter,
                colors: [
                  // ignore: deprecated_member_use
                  AppColors.black.withOpacity(0.8),
                  // ignore: deprecated_member_use
                  AppColors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height*0.06,
            left:8 ,
            right: 8,
            child: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBarButton(
                    onTap: ()=>Navigator.pop(context),
                     iconData: Icons.arrow_back_outlined,
                     hasPaddingBewteen: true,
                     ),
                     const SizedBox(width: 8,),
                     Row(
                      children: [
                        AppBarButton(
                          onTap: (){}, 
                          iconData: Icons.share,
                          hasPaddingBewteen: true,
                          ),
              
                      ],
                     ),
                ],
              ),
            ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.28,
              
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "General",
                            style: Theme.of(context).textTheme.bodyLarge!.
                            copyWith(color: AppColors.white,fontWeight: FontWeight.bold),
                            
                          ),
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Text(
                        article.title ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Trending . $formatedDate",
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    
                    decoration: BoxDecoration(
                     borderRadius:  BorderRadius.vertical(top: Radius.circular(36)),
                     color: AppColors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row( 
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(article.urlToImage??"assets/images/placeholder.png"),
                              ),
                              const SizedBox(width: 8),
                              Text(article.source?.name??"UNKNOWN",style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500),),
                            const SizedBox(height:24,),                         
                            ],                        
                          ),
                             Text((article.description??"")+(article.content??""),
                             style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.black),),
                        ],
                      ),
                    ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
