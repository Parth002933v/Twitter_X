import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/features/application/controller/explore_controller.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  String searchText = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: SearchBar(
              hintText: 'Search user',
              backgroundColor: MaterialStatePropertyAll(Colors.black),
              onChanged: (value) {
                searchText = value;
                setState(() {});
              },
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        body: ref.watch(searchUserProvider(searchText)).when(
          data: (user) {
            return ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                print(user[index].name);
                return ListTile(
                  leading: circularNetworkImage(
                    url: user[index].profilePic,
                    userID: user[index].uid,
                  ),
                  title: Text(user[index].name),
                );
              },
            );
          },
          error: (error, stackTrace) {
            print(error.toString());
            return ErrorPage(
                error: error.toString(), stack: stackTrace.toString());
          },
          loading: () {
            return const LoaderPage();
          },
        ),
      ),
    );
  }
}
