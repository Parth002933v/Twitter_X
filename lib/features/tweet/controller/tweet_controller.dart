import 'dart:io' as io;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_x/APIs/api.dart';
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/features/application/application.dart';
import 'package:twitter_x/features/application/view/home_view/view/home_view.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/main.dart';
import 'package:twitter_x/model/model.dart';

final tweetListForYouProvider = FutureProvider((ref) async {
  final list = ref.watch(tweetControllerProvider.notifier);
  return list._getTweets();
});

final userTweetProvider =
    FutureProvider.autoDispose.family((ref, String userID) async {
  final tweetControllerN = ref.watch(tweetControllerProvider.notifier);
  return tweetControllerN._getUserTweet(userID);
});

final getRetweetedTweetProvider =
    FutureProvider.family.autoDispose((ref, String documentId) async {
  final retweet = ref.watch(tweetControllerProvider.notifier);
  return retweet._getRetweetedTweet(documentId);
});

final tweetControllerProvider =
    StateNotifierProvider<_TweetControllerNotifier, bool>((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  final storageAPI = ref.watch(storageAPIProvider);
  return _TweetControllerNotifier(
    ref: ref,
    tweetAPI: tweetAPI,
    storageAPI: storageAPI,
  );
});

class _TweetControllerNotifier extends StateNotifier<bool> {
  final Ref _ref;
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  _TweetControllerNotifier({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<void> deleteTweet({
    required String documentId,
    required GetTweetModel currentTweet,
  }) async {
    final res = await _tweetAPI.deleteTweet(documentId: documentId);
    res.fold(
      (l) => UshowToast(text: l.error),
      (r) {
        UshowToast(text: "Tweet has been deleted");
        _storageAPI.deleteImage(fileIds: currentTweet.imageLinks);
      },
    );
  }

  Future<List<GetTweetModel>> _getUserTweet(String userID) async {
    List<GetTweetModel> tweets = [];

    final tweetList = await _tweetAPI.getUserTweet(userID);

    for (final tweet in tweetList) {
      if ((tweet.data["retweetOf"] as String).trim().isNotEmpty) {
        final retweet = await _getRetweetedTweet(tweet.data["retweetOf"]);
        final reTweetedTweet = GetTweetModel.fromMap(tweet.data, retweet);
        tweets.add(reTweetedTweet);
      } else {
        final reTweetedTweet = GetTweetModel.fromMap(tweet.data, null);
        tweets.add(reTweetedTweet);
      }
    }

    return tweets;
  }

  Future<List<GetTweetModel>> _getTweets() async {
    List<GetTweetModel> tweets = [];
    final tweetList = await _tweetAPI.getAllTweets();

    for (final tweet in tweetList) {
      if ((tweet.data["retweetOf"] as String).trim().isNotEmpty) {
        final retweet = await _getRetweetedTweet(tweet.data["retweetOf"]);

        if (retweet != null) {
          final reTweetedTweet = GetTweetModel.fromMap(tweet.data, retweet);
          tweets.add(reTweetedTweet);
        } else {
          final reTweetedTweet = GetTweetModel.fromMap(tweet.data, null);
          tweets.add(reTweetedTweet);
        }
      } else {
        final reTweetedTweet = GetTweetModel.fromMap(tweet.data, null);
        tweets.add(reTweetedTweet);
      }
    }

    return tweets;
  }

  Future<GetTweetModel?> _getRetweetedTweet(String documentId) async {
    final res = await _tweetAPI.getRetweetedTweet(documentId);

    return res.fold((l) => null, (r) {
      final data = GetTweetModel.fromMap(r.data, null);
      return data;
    });
  }

  Future<List<String>?> _uploadReTweetImage(
      {required List<io.File> Images}) async {
    final res = await _storageAPI.uploadImagesList(images: Images);

    return res.fold(
      (l) {
        state = false;
        UshowToast(text: l.error);
        return null;
      },
      (r) => r,
    );
  }

  void reTweet({
    required GetTweetModel tweet,
    required UserModel currentUser,
    String? currentUserTweetText,
    List<io.File>? currentUserTweetImages,
  }) async {
    state = true;

    if (currentUserTweetImages != null) {
      final reTweetImageLinks =
          await _uploadReTweetImage(Images: currentUserTweetImages);
      if (reTweetImageLinks != null) {
        final tweetModel = CreateTweetModel(
          text: currentUserTweetText ?? '',
          uid: currentUser.uid,
          imageLinks: reTweetImageLinks,
          tweetType: TweetType.text,
          likeIDs: [],
          retweetOf: tweet.id,
          commentIDs: [],
          tweetID: '',
          reShareCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          hashTags: currentUserTweetText == null
              ? []
              : _getHashtagFromTweetText(currentUserTweetText),
        );

        final res2 = await _tweetAPI.shareTweet(tweetModel);

        res2.fold((l) {
          state = false;
          UshowToast(text: l.error);
        }, (r) {
          state = false;
          nav.currentState!
              .pushAndRemoveUntil(Application.route(), (route) => false);
          UshowToast(text: 'ReTweeted!');
        });
      }
    } else {
      final tweetModel = CreateTweetModel(
        text: currentUserTweetText ?? '',
        uid: currentUser.uid,
        imageLinks: [],
        tweetType: TweetType.text,
        likeIDs: [],
        retweetOf: tweet.id,
        commentIDs: [],
        tweetID: '',
        reShareCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        hashTags: currentUserTweetText == null
            ? []
            : _getHashtagFromTweetText(currentUserTweetText),
      );

      final res2 = await _tweetAPI.shareTweet(tweetModel);

      res2.fold((l) {
        state = false;
        UshowToast(text: l.error);
      }, (r) {
        state = false;
        UshowToast(text: 'ReTweeted!');
      });
    }
  }

  void updateLike({
    required GetTweetModel tweetModel,
    required UserModel currentUser,
  }) async {
    final likes = tweetModel.likeIDs;

    if (likes.contains(currentUser.uid)) {
      likes.remove(currentUser.uid);
    } else {
      likes.add(currentUser.uid);
    }
    tweetModel.copyWith(likeIDs: likes);
    final res = await _tweetAPI.updateLikes(tweetModel);
    res.fold((l) => null, (r) => null);
  }

  void shareTweet({required List<io.File> images, required String text}) {
    if (text.isEmpty) {
      UshowToast(text: 'Please enter text');
    }

    if (images.isNotEmpty && text.isNotEmpty) {
      _shareImageTweet(images: images, text: text);
    }
    if (images.isEmpty && text.isNotEmpty) {
      _shareTextTweet(text: text);
    }
  }

  Future<void> _shareImageTweet(
      {required List<io.File> images, required String text}) async {
    state = true;
    final uid = _ref.read(currentUserDetailProvider).value!;

    final res1 = await _storageAPI.uploadImagesList(images: images);

    res1.fold((l) {
      state = false;
      UshowToast(text: l.error);
    }, (r) async {
      final hashtags = _getHashtagFromTweetText(text);

      final tweetModel = CreateTweetModel(
        text: text,
        uid: uid.uid,
        imageLinks: r,
        tweetType: TweetType.text,
        likeIDs: [],
        retweetOf: '',
        commentIDs: [],
        tweetID: '',
        reShareCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        hashTags: hashtags,
      );

      final res2 = await _tweetAPI.shareTweet(tweetModel);

      res2.fold((l) {
        state = false;
        UshowToast(text: l.error);
      }, (r) {
        state = false;
        nav.currentState!
            .pushAndRemoveUntil(Application.route(), (route) => false);
      });
    });
  }

  Future<void> _shareTextTweet({required String text}) async {
    state = true;
    final uid = _ref.read(currentUserDetailProvider).value!;
    final hashtags = _getHashtagFromTweetText(text);

    final tweetModel = CreateTweetModel(
      text: text,
      uid: uid.uid,
      imageLinks: [],
      tweetType: TweetType.text,
      likeIDs: [],
      retweetOf: '',
      commentIDs: [],
      hashTags: hashtags,
      tweetID: '',
      reShareCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final res = await _tweetAPI.shareTweet(tweetModel);

    res.fold(
      (l) {
        state = false;
        UshowToast(text: l.error);
      },
      (r) {
        state = false;
        nav.currentState!
            .pushAndRemoveUntil(HomeView.route(), (route) => false);
      },
    );
  }

  List<String> _getHashtagFromTweetText(String text) {
    final RegExp hashtagRegExp = RegExp(r'#(\w+)');
    final matches = hashtagRegExp.allMatches(text);

    return matches.map((match) => match.group(0)!).toList();
  }
}
