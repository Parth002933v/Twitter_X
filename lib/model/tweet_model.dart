import 'package:twitter_x/core/core.dart';

class CreateTweetModel {
  final String tweetID;
  final String text;
  final String uid;
  final List<String> imageLinks;
  final TweetType tweetType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> likeIDs;
  final List<String> commentIDs;
  final int reShareCount;
  final String retweetOf;
  final List<String> hashTags;
  CreateTweetModel({
    required this.text,
    required this.uid,
    required this.retweetOf,
    required this.imageLinks,
    required this.tweetType,
    required this.commentIDs,
    required this.likeIDs,
    required this.tweetID,
    required this.reShareCount,
    required this.createdAt,
    required this.updatedAt,
    required this.hashTags,
  });

  CreateTweetModel copyWith(
      {String? tweetID,
      String? text,
      String? uid,
      List<String>? imageLinks,
      TweetType? tweetType,
      DateTime? createdAt,
      DateTime? updatedAt,
      List<String>? likeIDs,
      List<String>? commentIDs,
      int? reShareCount,
      String? retweetOf,
      List<String>? hashTags}) {
    return CreateTweetModel(
      tweetID: tweetID ?? this.tweetID,
      text: text ?? this.text,
      uid: uid ?? this.uid,
      imageLinks: imageLinks ?? this.imageLinks,
      tweetType: tweetType ?? this.tweetType,
      likeIDs: likeIDs ?? this.likeIDs,
      commentIDs: commentIDs ?? this.commentIDs,
      reShareCount: reShareCount ?? this.reShareCount,
      retweetOf: retweetOf ?? this.retweetOf,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hashTags: hashTags ?? this.hashTags,
    );
  }

  Map<String, dynamic> toMap() => {
        "text": text,
        "imageLinks": List<String>.from(imageLinks.map((x) => x)),
        "tweetType": tweetType.type,
        "likeIDs": List<String>.from(likeIDs.map((x) => x)),
        "commentIDs": List<String>.from(commentIDs.map((x) => x)),
        "reShareCount": reShareCount,
        "retweetOf": retweetOf,
        "uid": uid,
        "hashTags": List<String>.from(hashTags.map((x) => x)),
      };
}

class GetTweetModel {
  final String text;
  final List<String> imageLinks;
  final String tweetType;
  final List<String> likeIDs;
  final List<String> commentIDs;
  final int reShareCount;
  // final String retweetOf;

  // final RetweetOf? retweetOf;
  final GetTweetModel? retweetOf;

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Uid uid;

  GetTweetModel({
    required this.text,
    required this.imageLinks,
    required this.tweetType,
    required this.likeIDs,
    required this.commentIDs,
    required this.reShareCount,
    // required this.retweetOf,
    this.retweetOf,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetTweetModel &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          imageLinks == other.imageLinks &&
          tweetType == other.tweetType &&
          likeIDs == other.likeIDs &&
          commentIDs == other.commentIDs &&
          reShareCount == other.reShareCount &&
          retweetOf == other.retweetOf &&
          id == other.id &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          uid == other.uid;

  @override
  int get hashCode =>
      text.hashCode ^
      imageLinks.hashCode ^
      tweetType.hashCode ^
      likeIDs.hashCode ^
      commentIDs.hashCode ^
      reShareCount.hashCode ^
      retweetOf.hashCode ^
      id.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      uid.hashCode;

  factory GetTweetModel.fromMap(
    Map<String, dynamic> json,
    GetTweetModel? retweet,
  ) =>
      GetTweetModel(
        text: json["text"],
        imageLinks: List<String>.from(json["imageLinks"].map((x) => x)),
        tweetType: json["tweetType"],
        likeIDs: List<String>.from(json["likeIDs"].map((x) => x)),
        commentIDs: List<String>.from(json["commentIDs"].map((x) => x)),
        reShareCount: json["reShareCount"],
        // retweetOf: json["retweetOf"],
        // retweetOf:
        //     retweet == null ? null : RetweetOf.fromMap(json["retweetOf"]),
        retweetOf: retweet == null ? null : retweet,

        id: json["\$id"],
        createdAt: DateTime.parse(json['\$createdAt']),
        updatedAt: DateTime.parse(json['\$updatedAt']),
        uid: Uid.fromMap(json["uid"]),
      );

  GetTweetModel copyWith({
    String? text,
    List<String>? imageLinks,
    String? tweetType,
    List<String>? likeIDs,
    List<String>? commentIDs,
    int? reShareCount,
    // String? retweetOf,
    // RetweetOf? retweetOf,
    GetTweetModel? retweetOf,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Uid? uid,
  }) {
    return GetTweetModel(
      text: text ?? this.text,
      imageLinks: imageLinks ?? this.imageLinks,
      tweetType: tweetType ?? this.tweetType,
      likeIDs: likeIDs ?? this.likeIDs,
      commentIDs: commentIDs ?? this.commentIDs,
      reShareCount: reShareCount ?? this.reShareCount,
      retweetOf: retweetOf ?? this.retweetOf,
      // retweetOf: retweetOf ?? this.retweetOf,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      uid: uid ?? this.uid,
    );
  }
}

class Uid {
  final String name;
  final String profilePic;
  final bool isVerified;
  final String id;

  Uid({
    required this.name,
    required this.profilePic,
    required this.isVerified,
    required this.id,
  });

  factory Uid.fromMap(Map<String, dynamic> json) => Uid(
        name: json["name"],
        profilePic: json["profilePic"],
        isVerified: json["isVerified"],
        id: json["\$id"],
      );
}

class RetweetOf {
  final String text;
  final List<dynamic> imageLinks;
  final String tweetType;
  final List<dynamic> likeIDs;
  final List<dynamic> commentIDs;
  final int reShareCount;
  final String id;
  final Uid uid;

  RetweetOf({
    required this.text,
    required this.imageLinks,
    required this.tweetType,
    required this.likeIDs,
    required this.commentIDs,
    required this.reShareCount,
    required this.id,
    required this.uid,
  });

  factory RetweetOf.fromMap(Map<String, dynamic> json) => RetweetOf(
        text: json["text"],
        imageLinks: List<dynamic>.from(json["imageLinks"].map((x) => x)),
        tweetType: json["tweetType"],
        likeIDs: List<dynamic>.from(json["likeIDs"].map((x) => x)),
        commentIDs: List<dynamic>.from(json["commentIDs"].map((x) => x)),
        reShareCount: json["reShareCount"],
        id: json["\$id"],
        uid: Uid.fromMap(json["uid"]),
      );
}
