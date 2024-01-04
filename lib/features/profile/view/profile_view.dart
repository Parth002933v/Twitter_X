import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/profile/components/components.dart';
import 'package:twitter_x/features/tweet/controller/tweet_controller.dart';

class UserProfileView extends ConsumerWidget {
  final String userID;

  static route({required String userID}) => MaterialPageRoute(
      builder: (context) => UserProfileView(
            userID: userID,
          ));
  const UserProfileView({super.key, required this.userID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetailP = ref.watch(userDetailProvider(userID));

    final currentUserDetailP = ref.watch(currentUserDetailProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: userDetailP.when(
          data: (userDetailData) {
            final userTweetList = ref.watch(userTweetProvider(userID));

            return NestedScrollView(
              clipBehavior: Clip.none,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverPersistentHeader(
                    delegate: CustomSliverAppbar(
                      expandedHegth: 170.w,
                      userDetailData: userDetailData,
                      ref: ref,
                    ),
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userDetail(
                            ProfileData: userDetailData,
                            context: context,
                            currentUser: currentUserDetailP.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverAppBar(
                    toolbarHeight: 20.h,
                    flexibleSpace: const TabBar(
                      labelPadding: EdgeInsets.all(1),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(text: 'Posts'),
                        Tab(text: 'Replies'),
                      ],
                    ),
                    pinned: true,
                    automaticallyImplyLeading: false,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  UserTweet(userTweet: userTweetList),
                  const Text('data'),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            return ErrorPage(
                error: error.toString(), stack: stackTrace.toString());
          },
          loading: () {
            return Loader();
          },
        ),
      ),
    );
  }
}
