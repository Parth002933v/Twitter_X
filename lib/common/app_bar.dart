import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/app_image.dart';
import 'package:twitter_x/constants/assets_constants.dart';

import '../constants/constants.dart';

AppBar buildAppbar({
  bool automaticallyImplyLeading = true,
  List<Widget>? actions,
  Widget? leading,
  PreferredSize? bottom,
}) {
  return AppBar(
    centerTitle: true,
    leadingWidth: 70.w,
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    title: svgIcon(
        icon: AssetsConstants.X, higth: 40, width: 40, color: Colors.white),
    actions: actions,
    bottom: bottom,
  );
}
