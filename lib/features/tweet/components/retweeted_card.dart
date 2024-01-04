import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/features/tweet/components/components.dart';
import 'package:twitter_x/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_x/features/tweet/view/tweet_detail_view.dart';
import 'package:twitter_x/model/model.dart';

@immutable
class RetweetedTweetCard extends ConsumerStatefulWidget {
  final GetTweetModel tweet;
  final UserModel currentUser;
  final bool canTapAvatar;
  final String screenForHeroTag;
  const RetweetedTweetCard({
    super.key,
    required this.tweet,
    required this.currentUser,
    this.canTapAvatar = true,
    required this.screenForHeroTag,
  });

  @override
  ConsumerState<RetweetedTweetCard> createState() => _RetweetedTweetCardState();
}

class _RetweetedTweetCardState extends ConsumerState<RetweetedTweetCard> {
  final GlobalKey _widgetKey = GlobalKey();
  Size? _widgetSize;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWidgetSize();
    });
  }

  void _getWidgetSize() {
    final RenderBox? renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    setState(() {
      _widgetSize = renderBox?.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        children: [
          //PERSON WHO RE TWEETED
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                PageTransition(
                  child: TweetDetail(
                      tweetData: widget.tweet, currentUser: widget.currentUser),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    circularNetworkImage(
                      shouldNavigate: widget.canTapAvatar,
                      url: widget.tweet.uid.profilePic,
                      userID: widget.canTapAvatar == false
                          ? null
                          : widget.tweet.uid.id,
                    ),
                    _widgetSize != null
                        ? Container(
                            width: 2,
                            height: _widgetSize!.height - 30,
                            color: Colors.grey,
                          )
                        : const SizedBox(),
                  ],
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    key: _widgetKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: widget.tweet.uid.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: " @${widget.tweet.uid.name}",
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
                        if (widget.tweet.text.trim().isNotEmpty)
                          TweetContentHandler(text: widget.tweet.text),
                        if (widget.tweet.imageLinks.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ImageGrid(
                              images: widget.tweet.imageLinks,
                              heroTag: "${widget.screenForHeroTag}",
                            ),
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
                              text: widget.tweet.reShareCount.toString(),
                              context: context,
                              onTap: () {
                                handleRetweetoption(
                                  context: context,
                                  tweet: widget.tweet,
                                  currentUser: widget.currentUser,
                                  ref: ref,
                                );
                              },
                            ),
                            LikeButton(
                              isLiked: widget.tweet.likeIDs
                                  .contains(widget.currentUser.uid),
                              size: 20,
                              likeCount: widget.tweet.likeIDs.length,
                              onTap: (isLiked) async {
                                // ),
                                ref
                                    .read(tweetControllerProvider.notifier)
                                    .updateLike(
                                      tweetModel: widget.tweet,
                                      currentUser: widget.currentUser,
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
                  ),
                )
              ],
            ),
          ),

          //THE RETWWED CONTENT
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                PageTransition(
                  child: TweetDetail(
                    tweetData: widget.tweet.retweetOf!,
                    currentUser: widget.currentUser,
                  ),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    circularNetworkImage(
                      shouldNavigate: widget.canTapAvatar,

                      // url: data.uid.profilePic,
                      url: widget.tweet.retweetOf!.uid.profilePic,
                      userID: widget.tweet.retweetOf!.uid.id,
                    ),
                  ],
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
                                text: widget.tweet.retweetOf!.uid.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text:
                                        " @${widget.tweet.retweetOf!.uid.name}",
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
                      TweetContentHandler(text: widget.tweet.retweetOf!.text),
                      if (widget.tweet.retweetOf!.imageLinks.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ImageGrid(
                            images: widget.tweet.retweetOf!.imageLinks,
                            heroTag: "${widget.screenForHeroTag}2",
                          ),
                        ),
                      const SizedBox(height: 10),
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
                            text:
                                widget.tweet.retweetOf!.reShareCount.toString(),
                            context: context,
                            onTap: () {
                              handleRetweetoption(
                                context: context,
                                tweet: widget.tweet.retweetOf!,
                                currentUser: widget.currentUser,
                                ref: ref,
                              );
                            },
                          ),
                          LikeButton(
                            isLiked: widget.tweet.retweetOf!.likeIDs
                                .contains(widget.currentUser.uid),
                            size: 20,
                            likeCount: widget.tweet.retweetOf!.likeIDs.length,
                            onTap: (isLiked) async {
                              return null;
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
          )
        ],
      ),
    );
  }
}
