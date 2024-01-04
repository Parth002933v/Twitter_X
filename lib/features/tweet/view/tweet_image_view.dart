import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x/common/app_image.dart';

class TweetImageView extends StatelessWidget {
  static route({required String image, required String heroTag}) =>
      PageTransition(
          child: TweetImageView(
            image: image,
            heroTag: heroTag,
          ),
          type: PageTransitionType.theme);
  TweetImageView({
    super.key,
    required this.image,
    required this.heroTag,
  });
  final String image;
  final String heroTag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: heroTag,
        child: AppNetworkImage(url: image),
      ),
    );
  }
}
