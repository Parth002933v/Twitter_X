import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/tweet/components/components.dart';
import 'package:twitter_x/features/tweet/controller/tweet_controller.dart';

import 'package:twitter_x/model/model.dart';
import 'package:twitter_x/theme/theme.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  static route({GetTweetModel? tweet}) =>
      MaterialPageRoute(builder: (context) => CreateTweetView(tweet: tweet));
  const CreateTweetView({super.key, this.tweet});
  final GetTweetModel? tweet;
  @override
  ConsumerState<CreateTweetView> createState() => _TweetViewState();
}

class _TweetViewState extends ConsumerState<CreateTweetView> {
  final _textController = TextEditingController();

  List<io.File> _images = [];

  _onPickImage() async {
    _images = await UpickMultipleImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUserP = ref.watch(currentUserDetailProvider).value;
    final tweetControllerN = ref.read(tweetControllerProvider.notifier);
    final tweetControllerP = ref.watch(tweetControllerProvider);

    return currentUserP == null
        ? const LoaderPage()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => tweetControllerP == true
                    ? null
                    : Navigator.of(context).pop(),
                icon: svgIcon(
                    color:
                        tweetControllerP == true ? Colors.grey : Colors.white,
                    icon: AssetsConstants.cross),
              ),
              actions: [
                RoundendSmallButton(
                  textColor: Colors.white,
                  color: PallateColor.blue,
                  isLoading: tweetControllerP,
                  text: 'Post',
                  onTap: () => widget.tweet != null
                      ? ref.read(tweetControllerProvider.notifier).reTweet(
                            currentUserTweetText: _textController.text.trim(),
                            currentUserTweetImages: _images,
                            tweet: widget.tweet!,
                            currentUser: currentUserP,
                          )
                      : tweetControllerN.shareTweet(
                          images: _images, text: _textController.text.trim()),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  circularNetworkImage(
                    url: currentUserP.profilePic,
                    userID: currentUserP.uid,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          maxLength: 280,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: null,
                          controller: _textController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: 'What\'s happening?',
                            border: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.w),
                          ),
                        ),
                        if (_images.isNotEmpty)
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _images.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 3,
                              crossAxisSpacing: 3,
                            ),
                            itemBuilder: (context, index) {
                              return Image.file(
                                _images[index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        SizedBox(height: 10.h),
                        if (widget.tweet != null)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            margin: EdgeInsets.only(right: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            child: circularNetworkImage(
                                              url: widget.tweet!.uid.profilePic,
                                              userID: widget.tweet!.uid.id,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          Expanded(
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                text: widget.tweet!.uid.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        " @${widget.tweet!.uid.name}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        widget.tweet!.text,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 7,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                ImageGrid(
                                  images: widget.tweet!.imageLinks,
                                  heroTag: 'CreateTweet',
                                  tweetData: widget.tweet!,
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              alignment: Alignment.center,
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white,
                    width: 0.6,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Spacer(flex: 1),
                  selection_button(
                    icon: AssetsConstants.image,
                    onTap: () {
                      _onPickImage();
                    },
                  ),
                  const Spacer(flex: 2),
                  selection_button(
                    icon: AssetsConstants.gif,
                    onTap: () {},
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  selection_button(
                    icon: AssetsConstants.emoji,
                    onTap: () {},
                  ),
                  const Spacer(flex: 6),
                ],
              ),
            ),
          );
  }
}
