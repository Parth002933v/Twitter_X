import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x_three/common/common.dart';
import 'package:twitter_x_three/core/core.dart';
import 'package:twitter_x_three/features/profile/components/components.dart';
import 'package:twitter_x_three/features/tweet/components/components.dart';
import 'package:twitter_x_three/model/model.dart';
import 'package:twitter_x_three/theme/theme.dart';

class TweetDetail extends ConsumerWidget {
  const TweetDetail({
    super.key,
    required this.tweetData,
    required this.currentUser,
  });
  final GetTweetModel tweetData;
  final UserModel currentUser;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                circularNetworkImage(
                  url: tweetData.uid.profilePic,
                  userID: tweetData.uid.id,
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tweetData.uid.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "@${tweetData.uid.name}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                currentUser.uid == tweetData.uid.id
                    ? iconButton(
                        icon: Icons.more_vert,
                        onTap: () {
                          AppBottomSheet(
                            context: context,
                            currentTweet: tweetData,
                            ref: ref,
                          );
                        },
                      )
                    : RoundendSmallButton(
                        isFilled: currentUser.following.contains(tweetData.uid)
                            ? false
                            : true,
                        text: currentUser.following.contains(tweetData.uid)
                            ? "Following"
                            : "Follow",
                        onTap: () {},
                      ),
              ],
            ),
            SizedBox(height: 5.h),
            TweetContentHandler(
                text: tweetData.text,
                style: Theme.of(context).textTheme.bodyLarge!),
            if (tweetData.imageLinks.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ImageGrid(images: tweetData.imageLinks),
              ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  UDateTime.getFormatedTimeInAM_PM_With_Date(
                    tweetData.createdAt,
                  ),
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
        ),
      ),
    );
  }
}
