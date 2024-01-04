import 'package:flutter/material.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/features/application/view/home_view/view/home_view.dart';
import 'package:twitter_x/features/auth/view/signUp_dashboard_view.dart';
import 'package:twitter_x/features/auth/view/sign_in_view/sign_In_view.dart';
import 'package:twitter_x/features/auth/view/sign_up_view/signup_view.dart';

class RouteModel {
  final String path;
  final Widget page;
  RouteModel({required this.path, required this.page});
}

// ignore_for_file: constant_identifier_names

class AppRoute {
  static final List<RouteModel> _routes = [
    RouteModel(
        path: AppRouteConstants.WELCOME, page: const SignUpOnboardView()),
    RouteModel(path: AppRouteConstants.SIGN_UP, page: const SignUpView()),
    RouteModel(path: AppRouteConstants.SIGN_IN, page: const SignInView()),
    RouteModel(path: AppRouteConstants.HOME, page: const HomeView()),
  ];

  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    var result = _routes.where((r) => r.path == settings.name);

    // Consumer(
    //   builder: (context, ref, child) {
    //     final user = ref.watch(currentUserProvider);
    //
    //     return user.when(
    //       data: (data) {
    //         if (data == null) {
    //           return MaterialPageRoute(
    //               builder: (_) => SignUpOnboard(), settings: settings);
    //         } else {
    //           return MaterialPageRoute(
    //               builder: (_) => Home(), settings: settings);
    //         }
    //       },
    //       error: (error, stackTrace) {
    //         return MaterialPageRoute(
    //           builder: (_) => LoaderPage(),
    //           settings: settings,
    //         );
    //       },
    //       loading: () {
    //         return MaterialPageRoute(
    //           builder: (_) => LoaderPage(),
    //           settings: settings,
    //         );
    //       },
    //     );
    //   },
    // );
    return MaterialPageRoute(
        builder: (_) => result.first.page, settings: settings);
  }
}
