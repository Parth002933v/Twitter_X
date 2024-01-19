import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/tweet/components/tweet_status_button.dart';
import 'package:twitter_x/model/tweet_model.dart';
import 'package:twitter_x/theme/pallate_color.dart';

@immutable
class TweetImageView extends ConsumerStatefulWidget {
  static route(
          {required String image,
          required String heroTag,
          required GetTweetModel tweetData}) =>
      PageTransition(
          child: TweetImageView(
            image: image,
            heroTag: heroTag,
            tweetData: tweetData,
          ),
          type: PageTransitionType.rightToLeft);
  TweetImageView({
    super.key,
    required this.image,
    required this.heroTag,
    required this.tweetData,
  });
  final String image;
  final String heroTag;
  final GetTweetModel tweetData;

  @override
  ConsumerState<TweetImageView> createState() => _TweetImageViewState();
}

class _TweetImageViewState extends ConsumerState<TweetImageView> {
  bool _isOverlayVisible = true;

  void _toggleOverlayVisibility() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
      if (!_isOverlayVisible) {

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: GestureDetector(
        onTap: () {
          _toggleOverlayVisibility();
        },
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: widget.heroTag,
                child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  child: AppNetworkImage(url: widget.image),
                ),
              ),
            ),
            _PositionedAppbar(context),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: SafeArea(
                child: AnimatedOpacity(
                  opacity: _isOverlayVisible == true ? 1 : 0,
                  duration: Duration(milliseconds: 400),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 15.h,
                      right: 20.w,
                      left: 20.w,
                    ),
                    height: 100,
                    color: Colors.black.withOpacity(0.6),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            postResponseIcon(
                              icon: AssetsConstants.comment,
                              text: '4',
                              context: context,
                              color: Colors.white,
                              onTap: () {},
                            ),
                            postResponseIcon(
                              icon: AssetsConstants.repeat,
                              // text: tweet.reShareCount.toString(),
                              color: Colors.white,

                              text: "2",
                              context: context,
                              onTap: () {
                                // handleRetweetoption(
                                //   context: context,
                                //   tweet: tweet,
                                //   currentUser: currentUser,
                                //   ref: ref,
                                // );
                              },
                            ),
                            LikeButton(
                              isLiked: widget.tweetData.likeIDs
                                  .contains(currentUser!.uid),
                              // isLiked: true,
                              size: 20,
                              likeCount: widget.tweetData.likeIDs.length,
                              // likeCount: 6,
                              onTap: (isLiked) async {
                                // ref
                                //     .read(tweetControllerProvider.notifier)
                                //     .updateLike(
                                //   tweetModel: tweet,
                                //   currentUser: currentUser,
                                // );
                                //
                                // return !isLiked;
                              },
                              likeBuilder: (isLiked) {
                                return isLiked == true
                                    ? svgIcon(
                                        icon: AssetsConstants.heart_filled,
                                        width: 10,
                                        higth: 10,
                                      )
                                    : svgIcon(
                                        icon: AssetsConstants.heart,
                                        width: 20,
                                        higth: 20,
                                        color: Colors.white,
                                      );
                              },
                            ),
                            postResponseIcon(
                                icon: AssetsConstants.graph,
                                text: '4',
                                color: Colors.white,
                                context: context,
                                onTap: () {}),
                            postResponseIcon(
                                icon: AssetsConstants.share,
                                context: context,
                                color: Colors.white,
                                onTap: () {}),
                          ],
                        ),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: PallateColor.unselectColor),
                            hintText: 'Post your reply',
                            focusedBorder: UnderlineInputBorder(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Positioned _PositionedAppbar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _isOverlayVisible == true ? 1 : 0,
        duration: Duration(milliseconds: 400),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: iconButton(
              icon: Icons.arrow_back,
              onTap: () {
                Navigator.of(context).pop();
              }),
          actions: [iconButton(icon: Icons.more_vert, onTap: () {})],
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
