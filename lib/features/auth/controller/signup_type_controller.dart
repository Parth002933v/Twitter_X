import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpTypeProvider = StateNotifierProvider.autoDispose<
    _SignUpTypeControllerNotifier, ESignUpType>((ref) {
  return _SignUpTypeControllerNotifier();
});

class _SignUpTypeControllerNotifier extends StateNotifier<ESignUpType> {
  _SignUpTypeControllerNotifier() : super(ESignUpType.email);

  void toggleType() {
    if (state == ESignUpType.email) {
      state = ESignUpType.phone;
    } else {
      state = ESignUpType.email;
    }
  }
}

enum ESignUpType {
  phone,
  email,
}
