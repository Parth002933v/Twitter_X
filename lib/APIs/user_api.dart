import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/model/model.dart';

final latestUserProfileProvider = StreamProvider((ref) {
  final userAPIP = ref.watch(UserAPIProvider);
  return userAPIP._getLatestUserProfileData();
});

final UserAPIProvider = Provider((ref) {
  final database = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return UserAPI(
    database: database,
    realtime: realtime,
  );
});

abstract class _IUserAPI {
  FutureEitherVoid saveUser({required UserModel userModel});
  Future<Document> getUserDetail(String uid);
  FutureEitherVoid updateProfile({required UserModel userModel});
  Stream<RealtimeMessage> _getLatestUserProfileData();
  // updateFollower({required String documentId, required UserModel userModel});

  Future<List<Document>> serachUser({required String name});
}

class UserAPI implements _IUserAPI {
  final Databases _databases;
  final Realtime _realtime;
  UserAPI({
    required Databases database,
    required Realtime realtime,
  })  : _databases = database,
        _realtime = realtime;

  @override
  FutureEitherVoid saveUser({required UserModel userModel}) async {
    try {
      await _databases.createDocument(
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
  Stream<RealtimeMessage> _getLatestUserProfileData() {
    return _realtime.subscribe([
      "databases.${AppWriteConstants.databaseID}.collections.${AppWriteConstants.UserCollectionID}.documents"
    ]).stream;
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

  updateFollowing({required String documentId, required UserModel userModel}) {
    _databases.updateDocument(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.UserCollectionID,
      documentId: documentId,
      data: {
        'following': userModel.following,
      },
    );
  }

  updateFollower({required String profileID, required UserModel userModel}) {
    _databases.updateDocument(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.UserCollectionID,
      documentId: profileID,
      data: {
        'follower': userModel.following,
      },
    );
  }

  Future<List<Document>> serachUser({required String name}) async {
    final res = await _databases.listDocuments(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.UserCollectionID,
      queries: [
        Query.search('name', name),
      ],
    );
    return res.documents;
  }
}
