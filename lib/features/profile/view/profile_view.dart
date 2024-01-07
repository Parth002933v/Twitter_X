import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x/APIs/api.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/profile/components/components.dart';
import 'package:twitter_x/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_x/model/model.dart';

class UserProfileView extends ConsumerWidget {
  final String userID;

  static route({required String userID}) => PageTransition(
        child: UserProfileView(
          userID: userID,
        ),
        type: PageTransitionType.rightToLeft,
      );
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
            UserModel copyUserData = userDetailData;
            final userTweetList = ref.watch(userTweetProvider(userID));

            final latestUserProfileP = ref.watch(latestUserProfileProvider);

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
                      child: latestUserProfileP.when(
                        data: (data) {
                          if (data.events.contains(
                              "databases.${AppWriteConstants.databaseID}.collections.${AppWriteConstants.UserCollectionID}.documents.${copyUserData.uid}.update")) {
                            copyUserData = UserModel.fromMap(data.payload);
                          }
                          return userDetail(
                            ProfileData: copyUserData,
                            context: context,
                            currentUser: currentUserDetailP.value,
                            ref: ref,
                          );
                        },
                        error: (error, stackTrace) {
                          return ErrorPage(
                              error: error.toString(),
                              stack: stackTrace.toString());
                        },
                        loading: () {
                          return userDetail(
                            ProfileData: copyUserData,
                            context: context,
                            currentUser: currentUserDetailP.value,
                            ref: ref,
                          );
                        },
                      ),
                    ),
                  ),
                  SliverAppBar(
                    surfaceTintColor: Colors.black,
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
