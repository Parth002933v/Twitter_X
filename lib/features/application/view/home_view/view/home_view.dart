import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/model/model.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/tweet/view/for_you_tweets.dart';

class HomeView extends ConsumerWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final load = ref.watch(authControllerProvider);
    final currentUserP = ref.watch(currentUserDetailProvider);

    return DefaultTabController(
      length: 2,
      child: currentUserP.when(
        data: (data) {
          return data == null
              ? const LoaderPage()
              : Scaffold(
                  appBar: buildAppbar(
                    automaticallyImplyLeading: false,
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: circularNetworkImage(
                        // radius: 15,
                        url: data.profilePic,
                        userID: data.uid,
                      ),
                    ),
                    actions: [
                      InkWell(
                        onTap: () {
                          ref.read(authControllerProvider.notifier).signOut();
                        },
                        child: svgIcon(
                            icon: AssetsConstants.setting, color: Colors.white),
                      ),
                      SizedBox(width: 15.w)
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size(double.infinity, 50.h),
                      child: const TabBar(
                        tabs: [
                          Text('For you'),
                          Text('Following'),
                        ],
                      ),
                    ),
                  ),
                  body: const TabBarView(
                    children: [
                      ForYou(),
                      Text('Following'),
                    ],
                  ),
                );
        },
        error: (error, stackTrace) {
          print(error.toString());
          return ErrorPage(
              error: 'Please Restart the Application',
              stack: stackTrace.toString());
        },
        loading: () {
          return const LoaderPage();
        },
      ),
    );
  }
}
