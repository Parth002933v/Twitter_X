import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/features/application/components/components.dart';
import 'package:twitter_x/features/application/controller/application_controller.dart';
import 'package:twitter_x/features/tweet/view/create_tweet_view.dart';

class Application extends ConsumerWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const Application());

  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNavBarP = ref.watch(BottomNavBarProvider);
    return Scaffold(
      body: IndexedStack(index: bottomNavBarP, children: UIConstant.viewList),
      bottomNavigationBar: applicationBottomNavigationBar(bottomNavBarP, ref),
      floatingActionButton: FloatingActionButton(
        // heroTag: 'test123',
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(
            PageTransition(
                child: CreateTweetView(), type: PageTransitionType.bottomToTop),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
