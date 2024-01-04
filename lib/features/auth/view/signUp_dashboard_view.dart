import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x_three/common/common.dart';
import 'package:twitter_x_three/constants/constants.dart';
import 'package:twitter_x_three/features/auth/controller/auth_controller.dart';
import 'package:twitter_x_three/features/auth/view/sign_in_view/sign_In_view.dart';
import 'package:twitter_x_three/features/auth/view/sign_up_view/signup_view.dart';
import 'package:twitter_x_three/features/auth/widgtes/or_divider_widgte.dart';
import 'package:twitter_x_three/theme/theme.dart';

class SignUpOnboardView extends ConsumerWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => SignUpOnboardView());
  const SignUpOnboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: buildAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 230.w,
                      child: Text(
                        'See what\'s happening in the world right now',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 4),
                    RoundedButton(
                      onTap: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .googleSignIn();
                      },
                      icon: AssetsConstants.google,
                      text: "Continue with Google",
                    ),
                    const DividerOr(),
                    RoundedButton(
                      text: "Create account",
                      onTap: () {
                        Navigator.of(context).push(SignUpView.route());
                        // .pushNamed(AppRouteConstants.SIGN_UP);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                text: 'By signin up, you agree to our ',
                children: const [
                  TextSpan(
                      text: 'Terms, Privacy Policy',
                      style: TextStyle(color: PallateColor.blue)),
                  TextSpan(text: ', and '),
                  TextSpan(
                    text: 'Cookie Use',
                    style: TextStyle(color: PallateColor.blue),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                text: 'Have an account already?  ',
                children: [
                  TextSpan(
                    text: 'Log in',
                    style: const TextStyle(color: PallateColor.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(SignInView.route());
                        //     .pushNamed(AppRouteConstants.SIGN_IN);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
