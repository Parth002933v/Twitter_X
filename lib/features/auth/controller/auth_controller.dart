import 'dart:io' as io;
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as pick;
import 'package:twitter_x/APIs/api.dart';
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/features/application/application.dart';
import 'package:twitter_x/features/auth/view/signUp_dashboard_view.dart';
import 'package:twitter_x/features/auth/view/sign_in_view/sign_In_view.dart';
import 'package:twitter_x/main.dart';
import 'package:twitter_x/model/model.dart';

final authControllerProvider =
    StateNotifierProvider<_AuthControllerNotifier, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  final userAPI = ref.watch(UserAPIProvider);
  final storageAPI = ref.watch(storageAPIProvider);
  return _AuthControllerNotifier(
    authAPI: authAPI,
    userAPI: userAPI,
    ref: ref,
    storageAPI: storageAPI,
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController._currentUser();
});

final currentUserDetailProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userData = ref.watch(userDetailProvider(currentUserId));
  return userData.value;
});

final userDetailProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController._getUserData(uid);
});

class _AuthControllerNotifier extends StateNotifier<bool> {
  final Ref _ref;
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  final StorageAPI _storageAPI;
  _AuthControllerNotifier({
    required AuthAPI authAPI,
    required Ref ref,
    required UserAPI userAPI,
    required StorageAPI storageAPI,
  })  : _ref = ref,
        _authAPI = authAPI,
        _userAPI = userAPI,
        _storageAPI = storageAPI,
        super(false);

  updateFollowerFollowing({
    required UserModel currentUser,
    required UserModel ProfileData,
  }) async {
    List<String> following = currentUser.following;
    if (currentUser.following.contains(ProfileData.uid)) {
      following.remove(ProfileData.uid);
    } else {
      following.insert(0, ProfileData.uid);
    }

    _userAPI.updateFollowing(
      documentId: currentUser.uid,
      userModel: currentUser.copyWith(following: following),
    );

    List<String> follower = ProfileData.follower;
    if (ProfileData.follower.contains(currentUser.uid)) {
      follower.remove(currentUser.uid);
    } else {
      follower.insert(0, currentUser.uid);
    }
    _userAPI.updateFollower(
      userModel: ProfileData.copyWith(follower: follower),
      profileID: ProfileData.uid,
    );
  }

  Future<String?> _uploadProfileImage(pick.XFile Image) async {
    final bannerRes = await _storageAPI.uploadImage(image: io.File(Image.path));

    return bannerRes.fold(
      (l) {
        state = false;
        UShowToast(text: l.error);
        return null;
      },
      (r) => r,
    );
  }

  void _updateProfileData({required UserModel userModel}) async {
    final res = await _userAPI.updateProfile(userModel: userModel);
    res.fold(
      (l) {
        state = false;
        UShowToast(text: l.error);
      },
      (r) => UShowToast(text: "Profile updated!"),
    );
    state = false;
  }

  void updateProfile({
    required String name,
    required String bio,
    pick.XFile? avatarImage,
    pick.XFile? bannerImage,
    required UserModel userMode,
  }) async {
    state = true;

    if (avatarImage != null || bannerImage != null) {
      if (avatarImage != null) {
        final avatarUplodeLink = await _uploadProfileImage(avatarImage);

        if (avatarUplodeLink != null) {
          final userModel = userMode.copyWith(
            name: name,
            bio: bio,
            profilePic: avatarUplodeLink,
          );

          _updateProfileData(userModel: userModel);
        }
      } else if (bannerImage != null) {
        final bannerImageLink = await _uploadProfileImage(bannerImage);

        if (bannerImageLink != null) {
          final userModel = userMode.copyWith(
            name: name,
            bio: bio,
            bannerPic: bannerImageLink,
          );

          _updateProfileData(userModel: userModel);
        }
      } else {
        final avatarImageLink = await _uploadProfileImage(avatarImage!);
        final bannerImageLink = await _uploadProfileImage(bannerImage!);

        if (avatarImageLink != null && bannerImageLink != null) {
          final userModel = userMode.copyWith(
            name: name,
            bio: bio,
            bannerPic: bannerImageLink,
            profilePic: avatarImageLink,
          );

          _updateProfileData(userModel: userModel);
        }
      }
    } else {
      final userModel = userMode.copyWith(bio: bio, name: name);

      _updateProfileData(userModel: userModel);
    }
  }

  Future<User?> _currentUser() => _authAPI.currentUser();

  void signUPEmail({
    required String email,
    required String password,
    required String username,
    required String confirmPassword,
  }) async {
    state = true;

    if (password != confirmPassword) {
      UShowToast(text: "Confirm password is not matched");
      state = false;
    } else {
      final res = await _authAPI.signUpWithEmail(
        email: email,
        password: password,
        username: username.trim().isEmpty ? UGetEmailUsername(email) : username,
      );
      res.fold((l) {
        state = false;

        return UShowToast(text: l.error);
      }, (r) async {
        print(r);
        final user = UserModel(
          name: r.name,
          email: email,
          profilePic: "",
          bannerPic: "",
          uid: r.$id,
          bio: "",
          isVerified: false,
          following: [],
          follower: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final res2 = await _userAPI.saveUser(userModel: user);

        res2.fold(
          (l) {
            state = false;

            return UShowToast(text: l.error);
          },
          (r) {
            state = false;
            nav.currentState!.pushReplacement(SignInView.route());
            return UShowToast(
                text: 'Account created successfully! Please login');
          },
        );
      });
    }
  }

  void signUpPhone({
    required String phone,
    required String password,
    required String username,
    required String confirmPassword,
  }) async {
    state = true;
    if (password != confirmPassword) {
      UShowToast(text: "Confirm password is not matched");
      state = false;
    } else {
      final res = await _authAPI.signUpWithEmail(
        email: phone,
        password: password,
        username: username.trim().isEmpty ? UGetEmailUsername(phone) : username,
      );
      res.fold((l) {
        state = false;

        return UShowToast(text: l.error);
      }, (r) async {
        print(r);
        final user = UserModel(
          name: r.name,
          email: phone,
          profilePic: "",
          bannerPic: "",
          uid: r.$id,
          bio: "",
          isVerified: false,
          following: [],
          follower: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final res2 = await _userAPI.saveUser(userModel: user);

        res2.fold(
          (l) {
            state = false;

            return UShowToast(text: l.error);
          },
          (r) {
            state = false;
            nav.currentState!.pushReplacement(SignInView.route());
            return UShowToast(
                text: 'Account created successfully! Please login');
          },
        );
      });
    }
  }

  void signIn({
    required String email,
    required String password,
  }) async {
    state = true;
    final res = await _authAPI.signIN(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) {
      return UShowToast(text: l.error);
    }, (r) {
      _ref.refresh(currentUserAccountProvider);

      nav.currentState!
          .pushAndRemoveUntil(Application.route(), (route) => false);
    });
  }

  void googleSignIn() async {
    state = true;
    final res = await _authAPI.googleSignin();

    res.fold((l) => UShowToast(text: l.error.toString()), (r) => null);
    state = false;
  }

  void signOut() async {
    state = true;
    final res = await _authAPI.signOut();
    res.fold((l) {
      state = false;

      return UShowToast(text: l.error);
    }, (r) {
      state = false;
      nav.currentState!
          .pushAndRemoveUntil(SignUpOnboardView.route(), (route) => false);
    });
  }

  Future<UserModel> _getUserData(String uid) async {
    final user = await _userAPI.getUserDetail(uid);
    final userModel = UserModel.fromMap(user.data);
    return userModel;
  }
}
