import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_x/features/tweet/view/create_tweet_view.dart';
import 'package:twitter_x/model/model.dart';
import 'package:twitter_x/theme/theme.dart';

Future<dynamic> handleRetweetoption({
  required BuildContext context,
  required GetTweetModel tweet,
  required UserModel currentUser,
  required WidgetRef ref,
}) {
  return showModalBottomSheet(
    backgroundColor: Colors.black,
    context: context,
    builder: (context) {
      return Container(
        height: 220.h,
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 30.h,
        ),
        // height: 100,
        child: Column(
          children: [
            Container(
              height: 5,
              width: 30.w,
              decoration: BoxDecoration(
                color: PallateColor.unselectColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            _selectRetweetOption(
              title: 'Repost',
              description: 'Share this post with your followers',
              context: context,
              onTap: () {
                ref
                    .read(tweetControllerProvider.notifier)
                    .reTweet(tweet: tweet, currentUser: currentUser);
                Navigator.of(context).pop();
              },
              icon: AssetsConstants.repeat,
            ),
            const SizedBox(height: 20),
            _selectRetweetOption(
              icon: AssetsConstants.edit,
              title: 'Quote',
              description:
                  'Add a comment, photo or GIF before you share this post',
              context: context,
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(CreateTweetView.route(tweet: tweet));
                // Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

InkWell _selectRetweetOption({
  required BuildContext context,
  required void Function() onTap,
  String description = 'enter description',
  String title = 'enter title',
  String icon = AssetsConstants.repeat,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        svgIcon(
          width: 25.w,
          higth: 25.h,
          icon: icon,
          color: PallateColor.unselectColor,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.normal,
                      color: PallateColor.unselectColor,
                    ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
