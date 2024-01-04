import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/model/model.dart';

final UserAPIProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return UserAPI(database: database);
});

abstract class IUserAPI {
  FutureEitherVoid saveUser({required UserModel userModel});
  Future<Document> getUserDetail(String uid);
  FutureEitherVoid updateProfile({required UserModel userModel});
}

class UserAPI implements IUserAPI {
  final Databases _databases;
  UserAPI({
    required Databases database,
  }) : _databases = database;

  @override
  FutureEitherVoid saveUser({required UserModel userModel}) async {
    try {
      await _databases.createDocument(
        databaseId: AppWriteConstants.databaseID,
        collectionId: AppWriteConstants.UserCollectionID,
        documentId: userModel.uid,
        data: userModel.toMap(),
        permissions: [
          // Permission.write(Role.any()),
          Permission.read(Role.any()),
          Permission.update(Role.any()),
          // Permission.delete(Role.any()),
          // Permission.read(Role.user(userModel.uid)),
          // Permission.update(Role.user(userModel.uid)),
          // Permission.delete(Role.user(userModel.uid)),
        ],
      );

      return Right(null);
    } on AppwriteException catch (e, stack) {
      print(e.toString());
      print(stack.toString());
      return Left(Failure(e.message.toString(), stack.toString()));
    } catch (e, stack) {
      return Left(Failure(e.toString(), stack.toString()));
    }
  }

  @override
  Future<Document> getUserDetail(String uid) async {
    final user = _databases.getDocument(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.UserCollectionID,
      documentId: uid,
    );
    return user;
  }

  @override
  FutureEitherVoid updateProfile({required UserModel userModel}) async {
    try {
      await _databases.updateDocument(
        databaseId: AppWriteConstants.databaseID,
        collectionId: AppWriteConstants.UserCollectionID,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );

      return Right(null);
    } on AppwriteException catch (e, stack) {
      print(e.toString());
      print(stack.toString());
      return Left(Failure(e.message.toString(), stack.toString()));
    } catch (e, stack) {
      return Left(Failure(e.toString(), stack.toString()));
    }
  }
}
