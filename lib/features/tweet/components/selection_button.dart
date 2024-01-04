import 'package:flutter/material.dart';

import '../../../common/common.dart';
import '../../../theme/theme.dart';

GestureDetector selection_button({
  required String icon,
  required void Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: svgIcon(
      icon: icon,
      color: PallateColor.blue,
      higth: 25,
      width: 25,
    ),
  );
}
