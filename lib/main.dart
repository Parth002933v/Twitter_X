// keytool -list -v -keystore C:\Users\pp542\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/features/application/application.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/auth/view/signUp_dashboard_view.dart';

import 'theme/theme_data.dart';

void main() {
  // BackgroundIsolateBinaryMessenger.ensureInitialized;
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,
  ));

  runApp(const ProviderScope(child: MyApp()));
}

final nav = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Twitter X',
        navigatorKey: nav,
        themeMode: ThemeMode.dark,
        darkTheme: TTheme.DarkTheme,
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        home: ref.watch(currentUserAccountProvider).when(
          data: (data) {
            // print('data');

            if (data == null) {
              return const SignUpOnboardView();
            } else {
              return const Application();
            }
          },
          error: (error, stackTrace) {
            return ErrorPage(
              error: error.toString(),
              stack: stackTrace.toString(),
            );
          },
          loading: () {
            // print('loading');
            return const LoaderPage();
          },
        ),
      ),
    );
  }
}
