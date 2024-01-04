import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x_three/constants/constants.dart';
import 'package:twitter_x_three/features/profile/view/profile_view.dart';
import 'package:twitter_x_three/main.dart';
import 'package:twitter_x_three/model/user_model.dart';

SizedBox svgIcon({
  String icon = AssetsConstants.google,
  double higth = 30,
  double width = 30,
  Color? color,
}) {
  return SizedBox(
    height: higth,
    width: width,
    child: SvgPicture.asset(
      icon,
      fit: BoxFit.contain,
      color: color,
    ),
  );
}

Widget circularNetworkImage(
    {required String url,
    String? userID,
    double width = 40,
    double height = 40,
    double? errorImageRadius,
    bool shouldNavigate = true}) {
  return url.isEmpty
      ? InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            userID == null || shouldNavigate == false
                ? null
                : nav.currentState!.push(
                    PageTransition(
                        child: UserProfileView(userID: userID),
                        type: PageTransitionType.rightToLeft),
                  );
          },
          child: CircleAvatar(
            radius: errorImageRadius,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(AssetsConstantsPNG.profile),
          ),
        )
      : InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            userID == null || shouldNavigate == false
                ? null
                : nav.currentState!.push(
                    PageTransition(
                        child: UserProfileView(userID: userID),
                        type: PageTransitionType.rightToLeft),
                  );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: SizedBox(
              height: height,
              width: width,
              child: AppNetworkImage(
                url: url,
                maxWidthDiskCache: 150,
                maxHeightDiskCache: 150,
              ),
            ),
          ),
        );
}

Widget AppNetworkImage({
  required String url,
  double? radius,
  int? maxWidthDiskCache,
  int? maxHeightDiskCache,
}) {
  return url.trim().isEmpty
      ? Container(color: Colors.blue)
      : CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          maxHeightDiskCache: maxHeightDiskCache,
          maxWidthDiskCache: maxWidthDiskCache,
          errorWidget: (context, url, error) {
            return svgIcon(icon: AssetsConstants.profile);
          },
        );
}

ClipRRect ImageGrid({required List<String> images}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
      ),
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          maxHeightDiskCache: 300.w.toInt(),
          maxWidthDiskCache: 300.w.toInt(),
          filterQuality: FilterQuality.none,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            return svgIcon(icon: AssetsConstants.profile);
          },
          imageUrl: images[index],
        );
      },
    ),
  );
}
