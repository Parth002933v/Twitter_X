import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/app_image.dart';
import 'package:twitter_x/common/loading_page.dart';
import 'package:twitter_x/constants/assets_constants.dart';

import '../constants/constants.dart';

class RoundendSmallButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final bool isFilled;
  final bool isLoading;
  final Color color;
  final Color textColor;
  final EdgeInsets? padding;
  const RoundendSmallButton({
    super.key,
    required this.onTap,
    this.text = 'enter the text',
    this.isFilled = true,
    this.isLoading = false,
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 60.w,
      onPressed: isLoading == true ? null : onTap,
      splashColor: Colors.grey,
      elevation: 0,
      padding: padding == null
          ? null
          : EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      color: isFilled == false ? Colors.transparent : color,
      shape: RoundedRectangleBorder(
        side: isFilled == false
            ? BorderSide(color: Colors.white, width: 1.5)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(30),
      ),
      child: isLoading == true
          ? SizedBox(
              height: 20.w,
              width: 20.w,
              child: Loader(),
            )
          : Text(
              text,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    height: 0,
                    color: isFilled == false ? Colors.white : textColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final String? icon;
  final void Function() onTap;
  const RoundedButton({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Colors.grey,
      height: 45,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon == null
              ? const SizedBox()
              : svgIcon(icon: AssetsConstants.google, width: 25.w, higth: 25.h),
          SizedBox(width: 10.w),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
