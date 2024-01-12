import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/profile/components/components.dart';
import 'package:twitter_x/main.dart';
import 'package:twitter_x/model/model.dart';

class CustomSliverAppbar extends SliverPersistentHeaderDelegate {
  final double expandedHegth;
  final UserModel userDetailData;
  final WidgetRef ref;
  CustomSliverAppbar({
    required this.expandedHegth,
    required this.userDetailData,
    required this.ref,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final top = -shrinkOffset + 90.h;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        _backgroundImage(
          shrinkOffset: shrinkOffset,
          bannerPic: userDetailData.bannerPic,
          context: context,
        ),
        _profilePic(
            top: top,
            radius: reverseShrinkOffset(shrinkOffset, expandedHegth),
            shrinkOffset: shrinkOffset,
            profileImage: userDetailData.profilePic),
        _buildAppBar(
            shrinkOffset: shrinkOffset,
            bannerPic: userDetailData.bannerPic,
            context: context,
            userID: userDetailData.uid,
            ref: ref),
      ],
    );
  }

  double reverseShrinkOffset(double shrinkOffset, double maxScrollOffset) {
    double reversedOffset = maxScrollOffset - shrinkOffset;

    return reversedOffset.clamp(0, maxScrollOffset);
  }

  @override
  double get maxExtent => expandedHegth;

  @override
  double get minExtent => kToolbarHeight + 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

Widget _buildAppBar({
  required double shrinkOffset,
  required String bannerPic,
  required BuildContext context,
  required String userID,
  required WidgetRef ref,
}) {
  return AnimatedOpacity(
    opacity: shrinkOffset < 50 ? 0 : 1,
    duration: const Duration(milliseconds: 100),
    child: AppBar(
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      leading: iconButton(
        onTap: () => nav.currentState!.pop(),
        icon: Icons.arrow_back,
      ),
      actions: [
        iconButton(icon: Icons.search_rounded, onTap: () {}),
        iconButton(
          icon: Icons.more_vert,
          onTap: () {
            showMenu(
              context: context,

              position: RelativeRect.fromLTRB(900.w, 50.h, 0, 0),
              items: [
                PopupMenuItem<String>(
                  onTap: () => ref.refresh(userDetailProvider(userID)),
                  value: '1',
                  child: Text('Refresh'),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text('Share'),
                ),
                PopupMenuItem<String>(
                  value: '3',
                  child: Text('Drafts'),
                ),
              ],

              // onSelected: (String value) {
              //   // Handle the selected value directly without using then
              //   print('Selected: $value');
              //   // Perform actions based on the selected value
              // },
            );
          },
        ),
      ],
      flexibleSpace: bannerPic.trim().isEmpty
          ? null
          : bannerPic.trim().isEmpty
              ? null
              : ClipRRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppNetworkImage(url: bannerPic),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: const SizedBox(),
                      ),
                    ],
                  ),
                ),
    ),
  );
}

Widget _backgroundImage({
  required double shrinkOffset,
  required String bannerPic,
  required BuildContext context,
}) {
  return AppBar(
    backgroundColor: Colors.blue,
    automaticallyImplyLeading: false,
    leading: iconButton(
      icon: Icons.arrow_back,
      onTap: () => nav.currentState!.pop(),
    ),
    actions: [
      iconButton(
        icon: Icons.search_rounded,
        onTap: () => UShowToast(text: "Taped"),
      ),
      iconButton(
        icon: Icons.more_vert,
        onTap: () {},
      ),
    ],
    flexibleSpace:
        bannerPic.trim().isEmpty ? null : AppNetworkImage(url: bannerPic),
  );
}

Positioned _profilePic({
  required double top,
  required double radius,
  required double shrinkOffset,
  required String profileImage,
}) {
  return Positioned(
    top: radius > 120 ? 120 : radius + 1,

    left: 20,
    child: Container(
      width: radius < 180 && radius > 100 ? radius / 2 + 4 : 49,
      height: radius < 180 && radius > 100 ? radius / 2 + 4 : 49,
      decoration: BoxDecoration(
        color: profileImage.trim().isEmpty ? Colors.blue : Colors.transparent,
        image: profileImage.trim().isEmpty
            ? const DecorationImage(
                image: AssetImage(AssetsConstantsPNG.profile),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: NetworkImage(profileImage),
                fit: BoxFit.cover,
              ),
        border: profileImage.trim().isEmpty
            ? null
            : Border.all(color: Colors.black, width: 3),
        shape: BoxShape.circle,
      ),
    ),
    // child: CircleAvatar(
    //   radius: radius < 150 && radius > 59 ? radius / 3 + 4 : 24,
    //   backgroundImage: AssetImage(AssetsConstantsPNG.profile),
    // ),
  );
}
