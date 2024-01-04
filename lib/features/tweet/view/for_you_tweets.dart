import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x_three/common/common.dart';
import 'package:twitter_x_three/features/auth/controller/auth_controller.dart';
import 'package:twitter_x_three/features/tweet/components/components.dart';
import 'package:twitter_x_three/features/tweet/controller/tweet_controller.dart';

class ForYou extends ConsumerWidget {
  const ForYou({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetListP = ref.watch(tweetListForYouProvider);
    final currentUserP = ref.watch(currentUserDetailProvider).value;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          return await ref.refresh(tweetListForYouProvider);
        },
        child: currentUserP == null
            ? const LoaderPage()
            : tweetListP.when(
                data: (data) {
                  return data.isNotEmpty
                      ? Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                addAutomaticKeepAlives: true,
                                cacheExtent: 2000,
                                physics: const AlwaysScrollableScrollPhysics(),
                                primary: true,
                                key: const PageStorageKey<String>("page"),
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 15.h),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final tweet = data[index];

                                  return tweet.retweetOf != null
                                      ? RetweetedTweetCard(
                                          tweet: tweet,
                                          currentUser: currentUserP,
                                        )
                                      : TweetCard(
                                          tweet: tweet,
                                          currentUser: currentUserP,
                                          ref: ref,
                                        );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(height: 200);
                },
                error: (error, stack) {
                  return ErrorPage(
                    error: error.toString(),
                    stack: stack.toString(),
                  );
                },
                loading: () {
                  return Loader();
                },
              ),
      ),
    );
  }
}

///
