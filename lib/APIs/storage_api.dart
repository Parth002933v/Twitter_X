import 'dart:developer';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_x/constants/constants.dart';
import 'package:twitter_x/core/core.dart';

final storageAPIProvider = Provider((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageAPI(storage: storage);
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  FutureEither<List<String>> uploadImagesList(
      {required List<File> images}) async {
    final List<String> imageLinks = [];

    try {
      for (File image in images) {
        final res = await _storage.createFile(
          bucketId: AppWriteConstants.storageID,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: image.path),
          onProgress: (p0) {},
        );
        imageLinks.add(AppWriteConstants.getImageURL(res.$id));
      }

      return Right(imageLinks);
    } catch (e, s) {
      return Left(Failure(e.toString(), s.toString()));
    }
  }

  FutureEither<String> uploadImage({required File image}) async {
    try {
      final res = await _storage.createFile(
        bucketId: AppWriteConstants.storageID,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: image.path),
        onProgress: (p0) {
          log(p0.progress.toString());
        },
      );

      return Right(AppWriteConstants.getImageURL(res.$id));
    } catch (e, s) {
      return Left(Failure(e.toString(), s.toString()));
    }
  }

  void deleteImage({required List<String> fileIds}) async {
    for (final fileId in fileIds) {
      await _storage.deleteFile(
          bucketId: AppWriteConstants.storageID, fileId: fileId);
    }
  }
}
