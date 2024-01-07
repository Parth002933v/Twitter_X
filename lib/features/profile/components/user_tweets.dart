import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/tweet/components/retweeted_card.dart';
import 'package:twitter_x/features/tweet/components/tweet_card.dart';
import 'package:twitter_x/model/model.dart';

class UserTweet extends ConsumerWidget {
  final AsyncValue<List<GetTweetModel>> userTweet;
  const UserTweet({super.key, required this.userTweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentUserP = ref.watch(currentUserDetailProvider).value;

    return userTweet.when(
      data: (data) {
        return data.isNotEmpty
            ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                primary: true,
                key: const PageStorageKey<String>("page2"),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final tweet = data[index];

                  return tweet.retweetOf != null
                      ? RetweetedTweetCard(
                          screenForHeroTag: 'ProfileReTweet${index}',
                          tweet: tweet,
                          canTapAvatar: false,
                          currentUser: _currentUserP!,
                        )
                      : TweetCard(
                          screenForHeroTag: 'ProfileTweet${index}',
                          tweet: tweet,
                          canTapAvatar: false,
                          currentUser: _currentUserP!,
                          ref: ref,
                        );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              )
            : const SizedBox(height: 200);
      },
      error: (error, stackTrace) {
        return ErrorPage(error: error.toString(), stack: stackTrace.toString());
      },
      loading: () {
        return Loader();
      },
    );
  }
}
