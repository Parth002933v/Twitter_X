import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_x_three/core/core.dart';

final authAPIProvider = Provider<AuthAPI>((ref) {
  final account = ref.watch(accountProvider);
  return AuthAPI(account: account);
});

abstract class IAuthAPI {
  Future<User?> currentUser();
  FutureEither<User> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  });
  // FutureEither<User> signUpWithPhone({
  //   required String phone,
  //   required String password,
  //   required String username,
  // });
  FutureEither<Session> signIN({
    required String email,
    required String password,
  });
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

  @override
  Future<User?> currentUser() async {
    try {
      final account = await _account.get();

      return account;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<User> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: username,
      );
      return Right(account);
    } on AppwriteException catch (e, stack) {
      switch (e.type) {
        case "user_already_exists":
          return left(
            Failure('User Already Exists Please Login', stack.toString()),
          );
        default:
          return left(
            Failure(e.message.toString(), stack.toString()),
          );
      }
    } catch (e, stack) {
      return left(
        Failure(e.toString(), stack.toString()),
      );
    }
  }

  // @override
  // FutureEither<User> signUpWithPhone({
  //   required String phone,
  //   required String password,
  //   required String username,
  // }) async {
  //   try {
  //     final account = await _account.create(
  //       userId: ID.unique(),
  //       email: phone,
  //       password: password,
  //       name: username,
  //     );
  //     return Right(account);
  //   } on AppwriteException catch (e, stack) {
  //     switch (e.type) {
  //       case "user_already_exists":
  //         return left(
  //           Failure('User Already Exists Please Login', stack.toString()),
  //         );
  //       default:
  //         return left(
  //           Failure(e.message.toString(), stack.toString()),
  //         );
  //     }
  //   } catch (e, stack) {
  //     return left(
  //       Failure(e.toString(), stack.toString()),
  //     );
  //   }
  // }

  @override
  FutureEither<Session> signIN({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.createEmailSession(
        email: email,
        password: password,
      );

      return Right(account);
    } on AppwriteException catch (e, stack) {
      return left(Failure(e.message.toString(), stack.toString()));
    } catch (e, stack) {
      return left(Failure(e.toString(), stack.toString()));
    }
  }

  FutureEither<void> googleSignin() async {
    try {
      // final res = await _account.createOAuth2Session(provider: 'google');
      // final res = await _account.create;

      // final res =
      //     _account.create(userId: userId, email: email, password: password);
      return Right(null);
    } on AppwriteException catch (e, stack) {
      print(e);
      print(stack);
      return left(Failure(e.message.toString(), stack.toString()));
    } catch (e, stack) {
      return left(Failure(e.toString(), stack.toString()));
    }
  }

  FutureEitherVoid signOut() async {
    try {
      await _account.deleteSessions();
      return Right(null);
    } on AppwriteException catch (e, stack) {
      return left(Failure(e.message.toString(), stack.toString()));
    } catch (e, stack) {
      return left(Failure(e.toString(), stack.toString()));
    }
  }
}
//
