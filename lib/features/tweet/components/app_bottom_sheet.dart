import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_x/model/tweet_model.dart';
import 'package:twitter_x/theme/theme.dart';

import 'package:twitter_x/constants/constants.dart';

AppBottomSheet({
  required BuildContext context,
  required GetTweetModel currentTweet,
  required WidgetRef ref,
}) {
  _handleDelete() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: ContinuousRectangleBorder(),
          actionsPadding: EdgeInsets.only(bottom: 0, right: 15.w, top: 0),
          contentPadding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10),
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w500),
          title: Text('Delete tweet?'),
          content: Text(
              'This can\'t be undone and it will be removed from your profile, the timeline of any accounts that follow you and from search results'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  ContinuousRectangleBorder(),
                ),
              ),
              child: Text('Cancel',
                  style: Theme.of(context).textTheme.titleMedium),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            TextButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  ContinuousRectangleBorder(),
                ),
              ),
              child: Text('Delete',
                  style: Theme.of(context).textTheme.titleMedium),
              onPressed: () {
                Navigator.of(dialogContext).pop();

                ref.read(tweetControllerProvider.notifier).deleteTweet(
                      documentId: currentTweet.id,
                      currentTweet: currentTweet,
                    );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  return showModalBottomSheet(
    backgroundColor: PallateColor.BackGoundColor,
    context: context,
    builder: (context) {
      return Container(
        height: 200.h,
        // padding: EdgeInsets.symmetric(
        //   horizontal: 20.w,
        //   vertical: 30.h,
        // ),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 40.w,
              margin: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: PallateColor.unselectColor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            _bottomSheetOption(
              context: context,
              icon: AssetsConstants.pin,
              text: "Pin to profile",
              onTap: () {},
            ),
            // SizedBox(height: 25),
            _bottomSheetOption(
              context: context,
              icon: AssetsConstants.delete,
              text: "Delete tweet",
              onTap: () {
                Navigator.of(context).pop();
                _handleDelete();
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _bottomSheetOption({
  required BuildContext context,
  required String text,
  required String icon,
  required void Function() onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10,
      ),
      child: Row(
        children: [
          svgIcon(
            icon: icon,
            color: PallateColor.unselectColor,
          ),
          SizedBox(width: 15),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          ),
        ],
      ),
    ),
  );
}
