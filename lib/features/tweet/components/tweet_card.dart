import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x_three/common/common.dart';
import 'package:twitter_x_three/constants/constants.dart';
import 'package:twitter_x_three/features/tweet/components/components.dart';
import 'package:twitter_x_three/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_x_three/features/tweet/view/tweet_detail_view.dart';
import 'package:twitter_x_three/model/model.dart';

class TweetCard extends StatelessWidget {
  const TweetCard({
    super.key,
    required this.tweet,
    required this.currentUser,
    required this.ref,
    this.canTapAvatar = true,
  });
  final GetTweetModel tweet;
  final UserModel currentUser;
  final WidgetRef ref;
  final bool canTapAvatar;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageTransition(
              child: TweetDetail(tweetData: tweet, currentUser: currentUser),
              type: PageTransitionType.rightToLeft,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                circularNetworkImage(
                  shouldNavigate: canTapAvatar,
                  url: tweet.uid.profilePic,
                  userID: tweet.uid.id,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: tweet.uid.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: " @${tweet.uid.name}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      TweetContentHandler(text: tweet.text),
                      if (tweet.imageLinks.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ImageGrid(images: tweet.imageLinks),
                        ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          postResponseIcon(
                              icon: AssetsConstants.comment,
                              text: '4',
                              context: context,
                              onTap: () {}),
                          postResponseIcon(
                            icon: AssetsConstants.repeat,
                            text: tweet.reShareCount.toString(),
                            context: context,
                            onTap: () {
                              handleRetweetoption(
                                context: context,
                                tweet: tweet,
                                currentUser: currentUser,
                                ref: ref,
                              );
                            },
                          ),
                          LikeButton(
                            isLiked: tweet.likeIDs.contains(currentUser.uid),
                            size: 20,
                            likeCount: tweet.likeIDs.length,
                            onTap: (isLiked) async {
                              ref
                                  .read(tweetControllerProvider.notifier)
                                  .updateLike(
                                    tweetModel: tweet,
                                    currentUser: currentUser,
                                  );

                              return !isLiked;
                            },
                            likeBuilder: (isLiked) {
                              return isLiked == true
                                  ? svgIcon(
                                      icon: AssetsConstants.heart_filled,
                                      width: 10,
                                      higth: 10,
                                    )
                                  : svgIcon(
                                      icon: AssetsConstants.heart,
                                      width: 20,
                                      higth: 20,
                                      color: Colors.grey,
                                    );
                            },
                          ),
                          postResponseIcon(
                              icon: AssetsConstants.graph,
                              text: '4',
                              context: context,
                              onTap: () {}),
                          postResponseIcon(
                              icon: AssetsConstants.share,
                              context: context,
                              onTap: () {}),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
