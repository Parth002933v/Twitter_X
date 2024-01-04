import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x/common/common.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';

class SignInView extends StatefulWidget {
  // static route() => MaterialPageRoute(builder: (context) => SignInView());
  static route() =>
      PageTransition(child: SignInView(), type: PageTransitionType.rightToLeft);

  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passowrdController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passowrdController.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To get Started, first enter your email',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 30.h),
                    AppTextField(
                      errorText: "Enter the username",
                      Controller: _emailController,
                      lableText: 'Enter your email',
                    ),
                    SizedBox(height: 30.h),
                    AppTextField(
                        obscureText: true,
                        errorText: "Enter the password",
                        Controller: _passowrdController,
                        lableText: 'Enter your password'),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 0),
          SizedBox(height: 15.h),
          Padding(
            padding: const EdgeInsets.only(right: 15, bottom: 10, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundendSmallButton(
                    onTap: () {}, isFilled: false, text: 'Forgot password?'),
                Consumer(
                  builder: (context, ref, child) {
                    final authControllerN =
                        ref.read(authControllerProvider.notifier);
                    final authControllerP = ref.watch(authControllerProvider);
                    return RoundendSmallButton(
                      isLoading: authControllerP,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authControllerN.signIn(
                            email: _emailController.text,
                            password: _passowrdController.text,
                          );
                        }
                      },
                      text: 'LogIn',
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
