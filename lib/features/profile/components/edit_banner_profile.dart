import 'dart:io' as io;
import 'package:image_picker/image_picker.dart' as pick;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x_three/common/common.dart';
import 'package:twitter_x_three/constants/constants.dart';

Widget editBanner({
  required String bannerPic,
  required void Function() onTap,
  pick.XFile? PickedImage,
}) {
  return InkWell(
    onTap: onTap,
    child: Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 150,
          width: double.maxFinite,
          child: PickedImage != null
              ? Image.file(
                  io.File(PickedImage.path),
                  fit: BoxFit.cover,
                )
              : AppNetworkImage(url: bannerPic),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        svgIcon(
          icon: AssetsConstants.camera,
          width: 40.w,
          higth: 40.w,
        )
      ],
    ),
  );
}

Positioned editAvatar({
  required String avatarPic,
  required void Function() onTap,
  pick.XFile? PickedImage,
}) {
  return Positioned(
    top: 110,
    left: 10,
    child: InkWell(
      borderRadius: BorderRadius.circular(90),
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              image: PickedImage == null
                  ? null
                  : DecorationImage(
                      image: FileImage(io.File(PickedImage.path)),
                      fit: BoxFit.cover,
                    ),
              color: Colors.transparent,
              border: Border.all(color: Colors.black, width: 4),
              shape: BoxShape.circle,
            ),
            child: PickedImage != null
                ? null
                : circularNetworkImage(
                    errorImageRadius: 40,
                    height: 90,
                    width: 90,
                    url: avatarPic,
                  ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          svgIcon(icon: AssetsConstants.camera, width: 35, higth: 35)
        ],
      ),
    ),
  );
}
