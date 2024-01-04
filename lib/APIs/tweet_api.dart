import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/model/model.dart';

final tweetAPIProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return TweetAPI(database: database);
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(CreateTweetModel tweetModel);
  Future<List<Document>> getAllTweets();
  FutureEither<Document> updateLikes(GetTweetModel tweetModel);
  FutureEither<Document> getRetweetedTweet(String documentId);
  Future<List<Document>> getUserTweet(String userID);
  FutureEitherVoid deleteTweet({required String documentId});
}

class TweetAPI implements ITweetAPI {
  final Databases _database;

  TweetAPI({required Databases database}) : _database = database;

  @override
  FutureEither<Document> shareTweet(CreateTweetModel tweetModel) async {
    try {
      final model = tweetModel.toMap();
      final res = await _database.createDocument(
        databaseId: AppWriteConstants.databaseID,
        collectionId: AppWriteConstants.tweetCollectionID,
        documentId: ID.unique(),
        data: model,
      );
      return Right(res);
    } on AppwriteException catch (e, stack) {
      return Left(Failure(e.message.toString(), stack.toString()));
    } catch (e, stack) {
      return Left(Failure(e.toString(), stack.toString()));
    }
  }

  @override
  Future<List<Document>> getAllTweets() async {
    final list = await _database.listDocuments(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.tweetCollectionID,
      queries: [
        Query.orderDesc('\$createdAt'),
      ],
    );
    return list.documents;
  }

  @override
  FutureEither<Document> updateLikes(GetTweetModel tweetModel) async {
    try {
      final update = await _database.updateDocument(
        databaseId: AppWriteConstants.databaseID,
        collectionId: AppWriteConstants.tweetCollectionID,
        documentId: tweetModel.id,
        data: {"likeIDs": tweetModel.likeIDs},
      );
      return Right(update);
    } on AppwriteException catch (e, s) {
      return Left(Failure(e.message.toString(), s.toString()));
    } catch (e, s) {
      return Left(Failure(e.toString(), s.toString()));
    }
  }

  @override
  FutureEither<Document> getRetweetedTweet(String documentId) async {
    try {
      final list = await _database.getDocument(
        databaseId: AppWriteConstants.databaseID,
        collectionId: AppWriteConstants.tweetCollectionID,
        documentId: documentId,
      );
      log('load retweet');
      return Right(list);
    } on AppwriteException catch (e, s) {
      return Left(Failure(e.message.toString(), s.toString()));
    } catch (e, s) {
      return Left(Failure(e.toString(), s.toString()));
    }
  }

  @override
  Future<List<Document>> getUserTweet(String userID) async {
    final list = await _database.listDocuments(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.tweetCollectionID,
      queries: [
        Query.orderDesc('\$createdAt'),
        Query.equal("uid", [userID])
      ],
    );
    return list.documents;
  }

  FutureEitherVoid deleteTweet({required String documentId}) async {
    try {
      final res = await _database.deleteDocument(
        databaseId: AppWriteConstants.databaseID,
        collectionId: AppWriteConstants.tweetCollectionID,
        documentId: documentId,
      );
      return Right(null);
    } on AppwriteException catch (e, s) {
      return Left(Failure(e.message.toString(), s.toString()));
    } catch (e, s) {
      return Left(Failure(e.toString(), s.toString()));
    }
  }
}
