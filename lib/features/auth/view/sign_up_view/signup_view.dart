import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_x_three/common/common.dart';
import 'package:twitter_x_three/features/auth/controller/auth_controller.dart';
import 'package:twitter_x_three/features/auth/controller/signup_type_controller.dart';

class SignUpView extends ConsumerStatefulWidget {
  // static route() => MaterialPageRoute(builder: (context) => SignUpView());
  static route() =>
      PageTransition(child: SignUpView(), type: PageTransitionType.rightToLeft);

  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool _isEmailFieldFocus = false;

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      final signUpTypeP = ref.read(signUpTypeProvider);

      ref.read(authControllerProvider.notifier).signUPEmail(
            email: _emailController.text,
            username: _usernameController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );

      // if (signUpTypeP == ESignUpType.email) {
      //   ref.read(authControllerProvider.notifier).signUPEmail(
      //         email: _emailController.text,
      //         username: _usernameController.text,
      //         password: _passwordController.text,
      //         confirmPassword: _confirmPasswordController.text,
      //       );
      // } else {
      //   ref.read(authControllerProvider.notifier).signUpPhone(
      //         phone: _phoneController.text,
      //         username: _usernameController.text,
      //         password: _passwordController.text,
      //         confirmPassword: _confirmPasswordController.text,
      //       );
      // }
    }
  }

  void _handleSignUpType(bool isFocus) {
    _isEmailFieldFocus = isFocus;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final signUpTypeP = ref.watch(signUpTypeProvider);
    final isSignUpTypeEmail = signUpTypeP == ESignUpType.email;
    return Scaffold(
      appBar: buildAppbar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppTextField(
                              // errorText: "Enter the username",pp542004@
                              Controller: _usernameController,
                              lableText: 'Name',
                            ),
                            SizedBox(height: 20.h),
                            // AppTextField(
                            //   Controller: isSignUpTypeEmail
                            //       ? _emailController
                            //       : _phoneController,
                            //   lableText: isSignUpTypeEmail ? 'Email' : "Phone",
                            //   errorText: isSignUpTypeEmail
                            //       ? "Enter the email"
                            //       : "Enter phone Number",
                            //   onTap: (bool) {
                            //     _handleSignUpType(bool);
                            //   },
                            // ),
                            AppTextField(
                              Controller: _emailController,
                              lableText: 'Email',
                              errorText: "Enter the email",
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              obscureText: true,
                              Controller: _passwordController,
                              lableText: 'Password',
                              errorText: 'Enter the password',
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              obscureText: true,
                              Controller: _confirmPasswordController,
                              lableText: 'Confirm Password',
                              errorText: 'Enter the Confirm password',
                            ),
                          ],
                        ),
                      ),
                    ),
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
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _isEmailFieldFocus == true
                      ? RoundendSmallButton(
                          onTap: () => ref
                              .read(signUpTypeProvider.notifier)
                              .toggleType(),
                          isFilled: false,
                          text: isSignUpTypeEmail
                              ? 'Use phone instead'
                              : 'Use email instead',
                        )
                      : null,
                ),
                RoundendSmallButton(
                  isLoading: ref.watch(authControllerProvider),
                  text: 'signup',
                  onTap: () {
                    _handleSignUp();
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
