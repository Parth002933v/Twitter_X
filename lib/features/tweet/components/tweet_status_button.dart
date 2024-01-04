import 'package:flutter/material.dart';

import '../../../common/common.dart';

Widget postResponseIcon({
  required String icon,
  String? text,
  required BuildContext context,
  required void Function() onTap,
  Color color = Colors.grey,
}) {
  return InkWell(
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: onTap,
    child: Row(
      children: [
        svgIcon(
          width: 20,
          higth: 20,
          icon: icon,
          color: color,
        ),
        SizedBox(width: 5),
        if (text != null)
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey),
          )
      ],
    ),
  );
}
