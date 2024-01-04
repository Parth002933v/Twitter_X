import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_x/common/common.dart';

class ConfirmSignin extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => ConfirmSignin());

  const ConfirmSignin({super.key});

  @override
  State<ConfirmSignin> createState() => _ConfirmSigninState();
}

class _ConfirmSigninState extends State<ConfirmSignin> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  SizedBox(height: 20.h),
                  AppTextField(
                      Controller: _emailController,
                      lableText: 'Enter your email'),
                ],
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
                    onTap: () {}, isFilled: true, text: 'Forgot password?'),
                RoundendSmallButton(onTap: () {}, text: 'Next'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
