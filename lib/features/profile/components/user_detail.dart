import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/profile/view/edit_profile.dart';
import 'package:twitter_x/model/model.dart';
import 'package:twitter_x/theme/theme.dart';

Column userDetail({
  required BuildContext context,
  required UserModel ProfileData,
  UserModel? currentUser,
  required WidgetRef ref,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: currentUser!.uid == ProfileData.uid
            ? RoundendSmallButton(
                isFilled: false,
                text: 'Edit profile',
                onTap: () {
                  Navigator.of(context).push(
                    PageTransition(
                        child: EditProfileView(currentUser: currentUser),
                        type: PageTransitionType.rightToLeft),
                  );
                },
              )
            : RoundendSmallButton(
                isFilled: currentUser.following.contains(ProfileData.uid)
                    ? false
                    : true,
                text: currentUser.following.contains(ProfileData.uid)
                    ? "Following"
                    : "Follow",
                onTap: () {
                  ref
                      .read(authControllerProvider.notifier)
                      .updateFollowerFollowing(
                        ProfileData: ProfileData,
                        currentUser: currentUser,
                      );
                },
              ),
      ),
      Text(
        ProfileData.name,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              height: 2,
            ),
      ),
      Text(
        '@${ProfileData.name}',
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: PallateColor.unselectColor),
      ),
      SizedBox(height: 15.h),
      if (ProfileData.bio.trim().isNotEmpty)
        Text(
          ProfileData.bio,
          style: Theme.of(context).textTheme.bodyMedium!,
        ),
      if (ProfileData.bio.trim().isNotEmpty) SizedBox(height: 20.h),
      Row(
        // alignment: WrapAlignment.center,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 12,
            color: PallateColor.unselectColor,
          ),
          SizedBox(width: 5.w),
          Text(
            'Surat, India',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: PallateColor.unselectColor),
          ),
          SizedBox(width: 10.w),
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                size: 12,
                color: PallateColor.unselectColor,
              ),
              SizedBox(width: 5.w),
              Text(
                'Joined ${UDateTime.getFormatedTimeInDate(ProfileData.createdAt)}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: PallateColor.unselectColor),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 10.h),
      Row(
        children: [
          Text(
            ProfileData.following.length.toString(),
            style: Theme.of(context).textTheme.titleSmall!,
          ),
          SizedBox(width: 5.w),
          Text(
            'Following',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: PallateColor.unselectColor),
          ),
          SizedBox(width: 10.w),
          Text(
            ProfileData.follower.length.toString(),
            style: Theme.of(context).textTheme.titleSmall!,
          ),
          SizedBox(width: 5.w),
          Text(
            'Followers',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: PallateColor.unselectColor),
          ),
        ],
      ),
    ],
  );
}
