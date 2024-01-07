import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/features/profile/view/profile_view.dart';
import 'package:twitter_x/features/tweet/components/components.dart';
import 'package:twitter_x/model/model.dart';
import 'package:twitter_x/theme/theme.dart';

class TweetDetail extends ConsumerStatefulWidget {
  const TweetDetail({
    super.key,
    required this.tweetData,
    required this.currentUser,
  });
  final GetTweetModel tweetData;
  final UserModel currentUser;

  @override
  ConsumerState<TweetDetail> createState() => _TweetDetailState();
}

class _TweetDetailState extends ConsumerState<TweetDetail> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: widget.tweetData.retweetOf == null
            ? _tweetDetailCard(context)
            : _repliedTweetDetailCard(context, ref),
      ),
    );
  }

  Column _tweetDetailCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            circularNetworkImage(
              url: widget.tweetData.uid.profilePic,
              userID: widget.tweetData.uid.id,
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tweetData.uid.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "@${widget.tweetData.uid.name}",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            widget.currentUser.uid == widget.tweetData.uid.id
                ? iconButton(
                    icon: Icons.more_vert,
                    onTap: () {
                      AppBottomSheet(
                        context: context,
                        currentTweet: widget.tweetData,
                        ref: ref,
                      );
                    },
                  )
                : RoundendSmallButton(
                    isFilled: widget.currentUser.following
                            .contains(widget.tweetData.uid)
                        ? false
                        : true,
                    text: widget.currentUser.following
                            .contains(widget.tweetData.uid)
                        ? "Following"
                        : "Follow",
                    onTap: () {},
                  ),
          ],
        ),
        SizedBox(height: 5.h),
        if (widget.tweetData.retweetOf != null)
          RichText(
            text: TextSpan(
              text: 'Replying to ',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: PallateColor.unselectColor),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(
                        UserProfileView.route(
                          userID: widget.tweetData.retweetOf!.uid.id,
                        ),
                      );
                    },
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: PallateColor.blue),
                  text: "@${widget.tweetData.retweetOf!.uid.name}",
                )
              ],
            ),
          ),
        SizedBox(height: 5.h),
        TweetContentHandler(
            text: widget.tweetData.text,
            style: Theme.of(context).textTheme.bodyLarge!),
        if (widget.tweetData.imageLinks.isNotEmpty)
          Container(
            key: UniqueKey(),
            margin: EdgeInsets.only(top: 10.h),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ImageGrid(
              images: widget.tweetData.imageLinks,
              heroTag: 'tweetDetail',
              tweetData: widget.tweetData,
            ),
          ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              UDateTime.getFormatedTimeInAM_PM_With_Date(
                widget.tweetData.createdAt.toLocal(),
              ),
              // tweetData.createdAt.toLocal().toString(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: PallateColor.unselectColor,
                  ),
            ),
            Text(
              '104K',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              " Views",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: PallateColor.unselectColor,
                  ),
            ),
          ],
        )
      ],
    );
  }

  Column _repliedTweetDetailCard(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                circularNetworkImage(
                  shouldNavigate: true,

                  // url: data.uid.profilePic,
                  url: widget.tweetData.retweetOf!.uid.profilePic,
                  userID: widget.tweetData.retweetOf!.uid.id,
                ),
                _widgetSize != null
                    ? Container(
                        width: 1.5,
                        height: _widgetSize!.height - 30,
                        color: Colors.grey.withOpacity(0.4),
                      )
                    : const SizedBox(),
              ],
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                key: _widgetKey,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: widget.tweetData.retweetOf!.uid.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text:
                                    " @${widget.tweetData.retweetOf!.uid.name}",
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
                  TweetContentHandler(text: widget.tweetData.retweetOf!.text),
                  if (widget.tweetData.retweetOf!.imageLinks.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ImageGrid(
                        images: widget.tweetData.retweetOf!.imageLinks,
                        heroTag: "2",
                        tweetData: widget.tweetData.retweetOf!,
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
                            widget.tweetData.retweetOf!.reShareCount.toString(),
                        context: context,
                        onTap: () {
                          handleRetweetoption(
                            context: context,
                            tweet: widget.tweetData.retweetOf!,
                            currentUser: widget.currentUser,
                            ref: ref,
                          );
                        },
                      ),
                      LikeButton(
                        isLiked: widget.tweetData.retweetOf!.likeIDs
                            .contains(widget.currentUser.uid),
                        size: 20,
                        likeCount: widget.tweetData.retweetOf!.likeIDs.length,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                circularNetworkImage(
                  url: widget.tweetData.uid.profilePic,
                  userID: widget.tweetData.uid.id,
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tweetData.uid.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "@${widget.tweetData.uid.name}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                widget.currentUser.uid == widget.tweetData.uid.id
                    ? iconButton(
                        icon: Icons.more_vert,
                        onTap: () {
                          AppBottomSheet(
                            context: context,
                            currentTweet: widget.tweetData,
                            ref: ref,
                          );
                        },
                      )
                    : RoundendSmallButton(
                        isFilled: widget.currentUser.following
                                .contains(widget.tweetData.uid)
                            ? false
                            : true,
                        text: widget.currentUser.following
                                .contains(widget.tweetData.uid)
                            ? "Following"
                            : "Follow",
                        onTap: () {},
                      ),
              ],
            ),
            SizedBox(height: 5.h),
            if (widget.tweetData.retweetOf != null)
              RichText(
                text: TextSpan(
                  text: 'Replying to ',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: PallateColor.unselectColor),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            UserProfileView.route(
                              userID: widget.tweetData.retweetOf!.uid.id,
                            ),
                          );
                        },
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: PallateColor.blue),
                      text: "@${widget.tweetData.retweetOf!.uid.name}",
                    )
                  ],
                ),
              ),
            SizedBox(height: 5.h),
            TweetContentHandler(
                text: widget.tweetData.text,
                style: Theme.of(context).textTheme.bodyLarge!),
            if (widget.tweetData.imageLinks.isNotEmpty)
              Container(
                key: UniqueKey(),
                margin: EdgeInsets.only(top: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ImageGrid(
                  images: widget.tweetData.imageLinks,
                  heroTag: 'tweetDetail',
                  tweetData: widget.tweetData,
                ),
              ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  UDateTime.getFormatedTimeInAM_PM_With_Date(
                    widget.tweetData.createdAt.toLocal(),
                  ),
                  // tweetData.createdAt.toLocal().toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: PallateColor.unselectColor,
                      ),
                ),
                Text(
                  '104K',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  " Views",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: PallateColor.unselectColor,
                      ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
